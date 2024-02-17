//
//  Appointment.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import Foundation

struct Appointment: Identifiable, Codable, Hashable {
    var id: Int
    var doctor: String?
    var patientFullname: String?
    var dateTime: String?
    var symptomsDesc: String?
    var mriImage: String?
    var xRayImage: String?
    var status: String?
    var updatedAt: String?
    var createdAt: String?
    var user: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctor
        case patientFullname = "patient_fullname"
        case dateTime = "date_time"
        case symptomsDesc = "symptoms_desc"
        case mriImage = "mri_image"
        case xRayImage = "x_ray_image"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case user
    }
}

struct AppointmentResponse: Codable {
    var count: Int?
    var totalPages: Int?
    var pageSize: Int?
    var current: Int?
    var previous: String?
    var next: String?
    var results: [Appointment]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case totalPages = "total_pages"
        case pageSize = "page_size"
        case current
        case previous
        case next
        case results
    }
}
