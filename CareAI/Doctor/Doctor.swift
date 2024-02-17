//
//  Doctor.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import Foundation

struct Doctor: Identifiable, Codable {
    var id: Int
    var organization: String
    var category: String
    var geoLocation: GeoLocation?
    var fullName: String
    var rating: String
    var description: String
    var price: String
    var phoneNumber: String
    var photo: String?
    var updatedAt: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case organization
        case category
        case geoLocation = "geo_location"
        case fullName = "full_name"
        case rating
        case description
        case price
        case phoneNumber = "phone_number"
        case photo
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
    
    struct GeoLocation: Codable {
        var latitude: Double
        var longitude: Double
    }
}

struct DoctorResponse: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var totalPages: Int?
    var pageSize: Int?
    var current: Int?
    var results: [Doctor]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case totalPages = "total_pages"
        case pageSize = "page_size"
        case current
        case results
    }
}

