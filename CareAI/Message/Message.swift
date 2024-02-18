//
//  Message.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import Foundation

struct Message: Identifiable {
    var id = UUID().uuidString
    var text: String?
    var voice: Data?
    var fromChatbot: Bool = false
}
