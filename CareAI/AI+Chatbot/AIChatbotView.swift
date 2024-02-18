//
//  AIChatbotView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct AIChatbotView: View {
    @StateObject private var aiChatbotVM = AIChatbotViewModel()
    @State private var pressing = false
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(aiChatbotVM.messages) { msg in
                    MessageContent(msg: msg)
                }
            }
            HStack {
//                Image(systemName: "mic.fill")
//                    .scaleEffect(pressing ? 1.5 : 1.0)
//                    .font(.headline)
//                    .padding(10.0)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10.0)
//                            .fill(Color.accentColor.opacity(0.3).gradient)
//                            .scaleEffect(pressing ? 1.5 : 1.0)
//                    }
//                    .gesture(
//                        DragGesture(minimumDistance: 0.0)
//                            .onChanged { _ in
//                                self.pressing = true
//                                aiChatbotVM.startRecording()
//                            }
//                            .onEnded { _ in
//                                self.pressing = false
//                                aiChatbotVM.stopRecording()
//                            }
//                    )
                TextField("Write...", text: $aiChatbotVM.textFieldText, axis: .vertical)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 45)
                    .lineLimit(5)
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color.secondary.opacity(0.3).gradient)
                    }
                Button(action: {
                    aiChatbotVM.sendMessage()
                }, label: {
                    Text("Send")
                })
            }
            .padding()
        }
        .onReceive(timer, perform: { _ in
            Task {
                await aiChatbotVM.checkPlayer()
            }
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("AI Medic Chatbot")
                    .font(.title3.bold())
            }
        }
        .task {
            do {
                try await aiChatbotVM.playMp3()
            } catch {
                print(error)
            }
        }
    }
    
    @ViewBuilder
    func MessageContent(msg: Message) -> some View {
        HStack {
            if !msg.fromChatbot {
                Spacer()
            }
            if let text = msg.text {
                Text(text)
                    .font(.headline)
                    .frame(maxWidth: 250, alignment: .leading)
                    .frame(minHeight: 50)
            }
            if let _ = msg.voice {
                HStack {
                    Button(action: {
                        aiChatbotVM.playPause(msg: msg)
                    }, label: {
                        if aiChatbotVM.isPlaying {
                            Image(systemName: "stop.fill")
                                .font(.headline)
                                .frame(width: 35, height: 35)
                                .padding(10)
                                .background {
                                    Circle()
                                        .fill(.secondary)
                                }
                        } else {
                            Image(systemName: "play.fill")
                                .font(.headline)
                                .frame(width: 35, height: 35)
                                .padding(10)
                                .background {
                                    Circle()
                                        .fill(.secondary)
                                }
                        }
                    })
                    .foregroundStyle(msg.fromChatbot ? Color.accentColor : .blue)
                    .frame(minHeight: 50)
                }
                .frame(width: 250, alignment: .leading)
            }
            if msg.fromChatbot {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(msg.fromChatbot ? Color.accentColor : .blue)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        AIChatbotView()
    }
}
