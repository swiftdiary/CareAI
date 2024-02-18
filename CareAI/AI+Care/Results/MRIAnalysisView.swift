//
//  MRIAnalysisView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct MRIAnalysisView: View {
    let arr: [ String : String ] =
        [
            "Mild Impairment. " : "MidImpairment"
        ]
    
    var body: some View {
        VStack {
            ScrollView {
                let el = arr.randomElement()!
                Image(el.value)
                Text(el.key)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("MRI/X-ray Results")
                    .font(.title2.bold())
            }
        }
    }
}

#Preview {
    NavigationStack {
        MRIAnalysisView()
    }
}
