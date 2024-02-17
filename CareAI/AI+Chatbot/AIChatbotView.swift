//
//  AIChatbotView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct AIChatbotView: View {
    var body: some View {
        VStack {
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("AI Medic Chatbot")
                    .font(.title3.bold())
            }
        }
    }
}

#Preview {
    NavigationStack {
        AIChatbotView()
    }
}
