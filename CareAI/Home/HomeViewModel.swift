//
//  HomeViewModel.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var doctors = [Doctor]()
    
    func getDoctors() async throws {
        let response = try await NetworkManager.shared.get("/api/v1/careai/doctors/", asType: DoctorResponse.self)
        if let results = response.results {
            await MainActor.run {
                self.doctors = results
            }
        } else {
            throw HomeViewModelError.noDoctors
        }
    }
}

enum ServiceName: Hashable, CaseIterable {
    case doctors
    case aiCare
    case pharmacy
    
    var title: String {
        switch self {
        case .doctors: "Doctors"
        case .aiCare: "AI Care"
        case .pharmacy: "Pharmacy"
        }
    }
    
    var icon: String {
        switch self {
        case .doctors: "DoctorServiceIcon"
        case .aiCare: "AICareServiceIcon"
        case .pharmacy: "PharmacyServiceIcon"
        }
    }
    
    var destinationValue: NavigationOption {
        switch self {
        case .doctors: NavigationOption.aiCare
        case .aiCare: NavigationOption.aiCare
        case .pharmacy: NavigationOption.aiCare
        }
    }
}

enum HomeViewModelError: Error {
    case noDoctors
}
