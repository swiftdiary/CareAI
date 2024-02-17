//
//  HomeVIew.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ServicesSection()
                MRIXRayImages()
                TopDoctors()
                ArticlesSection()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Home")
                    .font(.title2.bold())
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(.notificationIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            }
        }
        .task {
            do {
                try await homeVM.getDoctors()
            } catch {
                print(error)
            }
        }
    }
    
    @ViewBuilder
    func ServicesSection() -> some View {
        VStack(alignment: .leading) {
            Text("Services")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            Rectangle()
                .fill(Color.accentColor)
                .frame(height: 2)
            HStack {
                ForEach(ServiceName.allCases, id: \.self) { service in
                    VStack(spacing: 10) {
                        Image(service.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                        Text(service.title)
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                    .frame(width: 85)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 12.0)
                            .fill(Color.accentColor)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func MRIXRayImages() -> some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    HStack(spacing: 35) {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("MRI Analysis")
                                .font(.title2.bold())
                            Button(action: {
                                
                            }, label: {
                                Text("Analyze")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 35)
                                    .background {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(Color.accentColor)
                                    }
                            })
                            .foregroundStyle(.white)
                        }
                        Image(.doctor)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12.0)
                            .fill(Color.accentColor.opacity(0.3).gradient)
                    }
                    
                    // Chatbot
                    HStack(spacing: 35) {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("AI Medic Chatbot")
                                .font(.title2.bold())
                            Button(action: {
                                
                            }, label: {
                                Text("Start conversation")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 35)
                                    .background {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(Color.accentColor)
                                    }
                            })
                            .foregroundStyle(.white)
                        }
                        Image(.doctor)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12.0)
                            .fill(Color.accentColor.opacity(0.3).gradient)
                    }
                    
                    // Symptoms Analysis
                    HStack(spacing: 35) {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Symptoms analysis")
                                .font(.title2.bold())
                            Button(action: {
                                
                            }, label: {
                                Text("Analyze")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 35)
                                    .background {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(Color.accentColor)
                                    }
                            })
                            .foregroundStyle(.white)
                        }
                        Image(.doctor)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12.0)
                            .fill(Color.accentColor.opacity(0.3).gradient)
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func TopDoctors() -> some View {
        VStack(alignment: .leading) {
            Text("Top Doctors")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            Rectangle()
                .fill(Color.accentColor)
                .frame(height: 2)
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(homeVM.doctors) { doctor in
                            VStack(alignment: .leading, spacing: 10) {
                                AsyncImage(url: URL(string: doctor.photo ?? ""), scale: 1.0) { img in
                                    img
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                                Text("\(doctor.fullName.prefix(10).description)")
                                    .font(.headline)
                                Text("\(doctor.description.prefix(14).description)")
                                    .font(.subheadline)
                                Spacer()
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
                                        .font(.subheadline)
                                    
                                }
                            }
                            .frame(width: 140, height: 255, alignment: .top)
                            .padding(6)
                            .background {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 0.5)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    @ViewBuilder
    func ArticlesSection() -> some View {
        VStack(alignment: .leading) {
            Text("Articles")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            Rectangle()
                .fill(Color.accentColor)
                .frame(height: 2)
            VStack(spacing: 10) {
                ForEach(0..<15) { x in
                    HStack {
                        Image(.articleIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text("The 25 Healthiest Fruits You Can Eat, According to a Nutritionist")
                            .font(.headline)
                    }
                    Divider()
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
