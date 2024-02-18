//
//  AnalyzeSymptomsView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct AnalyzeSymptomsView: View {
    @EnvironmentObject private var navigation: AppNavigation
    @StateObject private var analyzeSymptomsVM = AnalyzeSymptomsViewModel()
    
    var body: some View {
        VStack(spacing: 25) {
            ScrollView {
                Image(.attachMriXray)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                TextField("Write your symptoms here...", text: $analyzeSymptomsVM.symptomsInputText, axis: .vertical)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 35)
                    .font(.system(size: 22))
                    .lineLimit(5)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color.secondary.opacity(0.3).gradient)
                    }
                    .padding()
                Button(action: {
                    Task {
//                        do {
//                            try await analyzeSymptomsVM.analyzeSymptoms()
//                        } catch {
//                            print(error)
//                        }
                        analyzeSymptomsVM.analyzeSymptomsWithCompletion(completion: {symptom,error in
                            if let error {
                                print(error)
                            } else if let symptom {
                                DispatchQueue.main.async {
                                    navigation.path.append(.results(symptom))
                                }
                            }
                        })
                    }
                }, label: {
                    Text("Analyze")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background {
                            RoundedRectangle(cornerRadius: 25.0)
                                .fill(Color.accentColor)
                        }
                })
                .foregroundStyle(.white)
                .padding()
            }
            .scrollDismissesKeyboard(.immediately)
        }
//        .onChange(of: analyzeSymptomsVM.symptomResponse, { oldValue, newValue in
//            if let newValue {
//                navigation.path.append(.results(newValue))
//            }
//        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Symptoms Analysis")
                    .font(.title3.bold())
            }
        }
    }
}

#Preview {
    NavigationStack {
        AnalyzeSymptomsView()
    }
}
