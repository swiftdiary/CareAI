//
//  AICareView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct AICareView: View {
    var body: some View {
        VStack {
            Image(.aiCare)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            Text("Hey! Please select the best option")
                .font(.headline)
            NavigationLink(value: NavigationOption.analyzeXrayMri) {
                Text("Analyze X-Ray/MRI Images")
                    .font(.headline)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.accentColor)
                    }
            }
            .foregroundStyle(.white)
            .padding()
            NavigationLink(value: NavigationOption.aiChatbot) {
                Text("AI Medic Chatbot")
                    .font(.headline)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.accentColor)
                    }
            }
            .foregroundStyle(.white)
            .padding()
            NavigationLink(value: NavigationOption.analyzeSymptoms) {
                Text("Symptoms Analysis")
                    .font(.headline)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.accentColor)
                    }
            }
            .foregroundStyle(.white)
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("AI Care")
                    .font(.title3.bold())
            }
        }
    }
}

#Preview {
    NavigationStack {
        AICareView()
    }
}
