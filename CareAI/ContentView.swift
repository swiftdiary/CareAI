//
//  ContentView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigationVM: AppNavigation = AppNavigation()
    var body: some View {
        CustomTab_Nav()
            .environmentObject(navigationVM)
    }
}

#Preview {
    ContentView()
}
