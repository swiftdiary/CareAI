//
//  CustomTab+Nav.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import SwiftUI

struct CustomTab_Nav: View {
    @State private var selection: TabBarOption = .home
    @EnvironmentObject private var navigationVM: AppNavigation
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection, content: {
                ForEach(TabBarOption.allCases, id: \.self) { option in
                    NavigationStack(path: $navigationVM.path) {
                        option.view
                            .navigationDestination(for: NavigationOption.self) { $0.destination.environmentObject(navigationVM) }
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
            })
            ZStack {
                if navigationVM.isTabBarVisible == false {
                    EmptyView()
                } else {
                    HStack {
                        ForEach(TabBarOption.allCases, id: \.self) { option in
                            VStack(spacing: 5) {
                                Image("\(option.iconName)\(selection == option ? ".fill" : "")")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(selection == option ? .accent : .primary)
                                if selection == option {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 8, height: 8)
                                        .matchedGeometryEffect(id: "TabBarItem", in: namespace)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 8)
                            .background {
                                if selection == option {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(Color.accentColor.gradient.opacity(0.15))
                                        
                                } else {
                                    EmptyView()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selection = option
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(.bar)
                            .overlay {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 0.1)
                                    .foregroundStyle(.primary)
                            }
                    )
                    .shadow(radius: 1.0)
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    CustomTab_Nav().environmentObject(AppNavigation())
}
