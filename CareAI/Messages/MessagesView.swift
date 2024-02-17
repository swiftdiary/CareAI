//
//  MessagesView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import SwiftUI

struct MessagesView: View {
    var body: some View {
        VStack {
            ScrollView {
                TopSegmentedControl()
                ForEach(0..<10) { x in
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .foregroundStyle(Color.accentColor, Color.accentColor.opacity(0.3).gradient)
                        Text("Joe")
                            .font(.title.bold())
                        Spacer()
                    }
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(Color.accentColor)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Messages")
                    .font(.title2.bold())
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
        }
    }
    
    @ViewBuilder
    func TopSegmentedControl() -> some View {
        HStack(spacing: 0) {
            Button(action: {
                
            }, label: {
                Text("All")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color.accentColor)
                    }
            })
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            Button(action: {
                
            }, label: {
                Text("Group")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background {
                        
                    }
            })
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            Button(action: {
                
            }, label: {
                Text("Private")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background {
                        
                    }
            })

            .foregroundStyle(.white)
        }
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.secondary.gradient)
        )
        .padding()
    }
}

#Preview {
    NavigationStack {
        MessagesView()
    }
}
