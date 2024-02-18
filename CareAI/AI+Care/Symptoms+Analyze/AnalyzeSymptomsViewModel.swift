//
//  AnalyzeSymptomsViewModel.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import Foundation

final class AnalyzeSymptomsViewModel: ObservableObject {
    @Published var symptomsInputText: String = ""
    @Published var symptomResponse: SymptomResponse?
    
//    func analyzeSymptoms() async throws {
//        let response = try await OpenAIManager.shared.post("/api/v1/careai/symptom-analysis/", jsonBody: [
//            "symptoms" : symptomsInputText
//        ], asType: SymptomResponse.self)
//        await MainActor.run {
//            symptomResponse = response
//        }
//    }
    
    func analyzeSymptomsWithCompletion(completion: @escaping (SymptomResponse?, Error?) -> ()) {
        guard let url = URL(string: NetworkManager.baseURL + "/api/v1/careai/symptom-analysis/") else {
            print("Invalid URL")
            completion(nil, OpenAIManagerError.urlError)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Set headers
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: [
                "symptoms" : symptomsInputText
            ])
        } catch {
            print("Error encoding JSON body: \(error)")
            completion(nil, error)
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error making API request: \(error)")
                completion(nil, error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("Invalid data or response")
                completion(nil, error)
                return
            }
            if response.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(SymptomResponse.self, from: data)
                    completion(result, nil)
                    print("Completed successfully")
                } catch {
                    print("Error decoding JSON response: \(error)")
                    completion(nil, error)
                }
            } else {
                print("Error: HTTP status code \(response.statusCode)")
                print("Data: \(response.description)")
                completion(nil, error)
            }
        }
        task.resume()
    }
}

struct SymptomResponse: Codable, Hashable {
    var diseaseCategory: String?
    var disease: String?
    var recommendedDoctors: [Doctor]?
    enum CodingKeys: String, CodingKey {
        case diseaseCategory = "disease_category"
        case disease
        case recommendedDoctors = "recommended_doctors"
    }
}
