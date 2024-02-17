//
//  Navigation.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import SwiftUI

final class AppNavigation: ObservableObject {
    @Published var path: [NavigationOption] = [] {
        didSet {
            if !path.isEmpty {
                withAnimation(.bouncy) {
                    self.isTabBarVisible = false
                }
            } else {
                withAnimation(.bouncy) {
                    self.isTabBarVisible = true
                }
            }
        }
    }
    
    @Published var isTabBarVisible: Bool = true
}

enum NavigationOption: Hashable {
    case aiCare
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .aiCare: Text("des")
        }
    }
}

enum TabBarOption: Hashable, CaseIterable {
    case home
    case messages
    case schedules
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            HomeView().tag(self)
        case .messages:
            MessagesView().tag(self)
        case .schedules:
            ScheduleView().tag(self)
        }
    }
    
    var iconName: String {
        switch self {
        case .home: "tab.home"
        case .messages: "tab.messages"
        case .schedules: "tab.schedules"
        }
    }
}
