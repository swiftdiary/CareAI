//
//  Date+Extensions.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import Foundation

extension Date {
    func format(_ format: String = "MM/dd/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tashkent")

        return dateFormatter.string(from: self)
    }
}

// String
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tashkent")

        return dateFormatter.date(from: self)
    }
}
