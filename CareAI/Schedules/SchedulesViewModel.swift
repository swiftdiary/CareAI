//
//  SchedulesViewModel.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import Foundation

final class SchedulesViewModel: ObservableObject {
    @Published var selectedType: ScheduleType = .pending {
        didSet {
            Task {
                do {
                    try await self.getSchedules()
                    await MainActor.run {
                        self.appointments = self.appointments.filter({$0.status == selectedType.rawValue})
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    @Published var appointments = [Appointment]()
    
    func getSchedules() async throws {
        let response = try await NetworkManager.shared.get("/api/v1/careai/appointments/", asType: AppointmentResponse.self)
        if let results = response.results {
            await MainActor.run {
                self.appointments = results
            }
        } else {
            throw ScheduleViewModelError.noAppointments
        }
    }
}

enum ScheduleType: String, Hashable, CaseIterable {
    case pending = "P"
    case approved = "A"
    case rejected = "R"
    
    var title: String {
        switch self {
        case .pending: "Pending"
        case .approved: "Approved"
        case .rejected: "Rejected"
        }
    }
}

enum ScheduleViewModelError: Error {
    case noAppointments
}
