//
//  AnalyzeXrayMriViewModel.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI
import PhotosUI

final class AnalyzeXrayMriViewModel: ObservableObject {
    @Published var image: Image?
    @Published var imageItem: PhotosPickerItem?
    
}
