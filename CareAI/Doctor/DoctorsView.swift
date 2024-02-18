//
//  DoctorsView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct DoctorsView: View {
    @StateObject private var doctorsVM = DoctorsViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(doctorsVM.doctors) { doc in
                    HStack {
                        
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Doctors")
                    .font(.title2.bold())
            }
        }
    }
}

#Preview {
    NavigationStack {
        DoctorsView()
    }
}
