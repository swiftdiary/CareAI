//
//  AnalysisResultsView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct AnalysisResultsView: View {
    var body: some View {
        VStack {
            ScrollView {
                Image(.analysisResults)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                VStack(spacing: 20) {
                    Text("Oh... It Seems you have a <Illness>")
                        .font(.headline)
                    Text("We recommend you to schedule an appointment with...")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                DoctorsList()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Results")
                    .font(.title3.bold())
            }
        }
    }
    
    @ViewBuilder
    func DoctorsList() -> some View {
        VStack {
            // ForEach...
            HStack {
                Image(.doctor)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(10)
                    .background {
                        Circle()
                            .fill(Color.green.gradient)
                    }
                VStack(alignment: .leading) {
                    Text("Dr. Dre dre")
                        .font(.headline)
                    Text("Cordiologist")
                        .foregroundStyle(.secondary)
                    HStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                            Text("4.9")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.accentColor)
                        .padding(4.0)
                        .background {
                            RoundedRectangle(cornerRadius: 6.0)
                                .fill(Color.accentColor.opacity(0.3))
                        }
                        Text("800m away")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 50.0)
                    .stroke(lineWidth: 1.0)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        AnalysisResultsView()
    }
}
