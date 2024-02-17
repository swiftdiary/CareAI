//
//  AnalyzeSymptomsView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct AnalyzeSymptomsView: View {
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
