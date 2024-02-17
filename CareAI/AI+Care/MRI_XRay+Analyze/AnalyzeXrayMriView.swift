//
//  AnalyzeXrayMriView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI
import PhotosUI

struct AnalyzeXrayMriView: View {
    @StateObject private var analyzeXrayMriVM = AnalyzeXrayMriViewModel()
    
    var body: some View {
        VStack(spacing: 25) {
            Image(.attachMriXray)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
            Text("Upload your X-Ray Scan or MRI Image")
            
            if let image = analyzeXrayMriVM.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            analyzeXrayMriVM.image = nil
                            analyzeXrayMriVM.imageItem = nil
                        }, label: {
                            Image(systemName: "minus")
                                .font(.headline)
                                .frame(width: 25, height: 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(Color.red.gradient)
                                }
                        })
                        .foregroundStyle(.white)
                    }
            } else {
                PhotosPicker(selection: $analyzeXrayMriVM.imageItem, matching: .images) {
                    VStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundStyle(Color.accentColor)
                    }
                    .frame(width: 200, height: 200)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(style: .init(lineWidth: 0.5, lineCap: .butt, lineJoin: .round, miterLimit: .infinity, dash: [12], dashPhase: 2))
                    }
                }
            }
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
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("MRI/X-Ray Image")
                    .font(.title3.bold())
            }
        }
        .onChange(of: analyzeXrayMriVM.imageItem) { oldValue, newValue in
            Task {
                if let loaded = try? await newValue?.loadTransferable(type: Image.self) {
                    self.analyzeXrayMriVM.image = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AnalyzeXrayMriView()
    }
}
