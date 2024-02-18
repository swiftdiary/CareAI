//
//  AIChatbotViewModel.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import Foundation
import AVFoundation
import Alamofire

final class AIChatbotViewModel: ObservableObject {
    @Published var messages: [Message] = [] {
        didSet {
            
        }
    }
    @Published var textFieldText: String = ""
    @Published var isPlaying: Bool = false
    
    var player: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    func playMp3(input: String = "Welcome to AI Care. Do you have any questions?") async throws {
        let data = try await OpenAIManager.shared.postAudio(input: input)
        try await MainActor.run {
            messages.append(.init(voice: data, fromChatbot: true))
        }
    }
    
    func sendMessage() {
        DispatchQueue.main.async {
            self.messages.append(Message(text: self.textFieldText, fromChatbot: false))
            self.textFieldText = ""
        }
        OpenAIManager.shared.getPredictionResult(input: textFieldText) { result, error in
            if let error {
                print("Error", error)
            } else if let result {
                DispatchQueue.main.async {
                    self.messages.append(Message(text: result, fromChatbot: true))
                }
            }
        }
    }
    
    func startRecording() {
        // Set up recording settings
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let audioSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        // Set up file URL for recording
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("audioRecording.wav")

        // Initialize AVAudioRecorder
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: audioSettings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch {
            print("Error initializing recorder: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("audioRecording.wav")
        let msg = Message(voice: try! Data(contentsOf: audioFilename), fromChatbot: false)
        DispatchQueue.main.async {
            self.messages.append(msg)
        }
        speechToText(msg: msg)
    }
    
    @MainActor
    func playPause(msg: Message) {
        do {
            if (isPlaying) {
                player?.stop()
            } else {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
                self.player = try AVAudioPlayer(data: msg.voice!)
                player?.play()
            }
            isPlaying = player?.isPlaying ?? false
        } catch {
            print(error)
        }
    }
    
    func checkPlayer() async {
        if let player, isPlaying, !player.isPlaying {
            await MainActor.run {
                isPlaying = false
            }
        }
    }
    
    func speechToText(msg: Message) {
        if let voice = msg.voice {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsDirectory.appendingPathComponent("openai.wav")
            try? voice.write(to: audioFilename)
            OpenAIManager.shared.sendAudio(audioFileURL: audioFilename, model: "whisperer-1") { response, error in
                if let error {
                    print(error)
                } else if let response {
                    print(response)
                }
            }
        }
    }
}
