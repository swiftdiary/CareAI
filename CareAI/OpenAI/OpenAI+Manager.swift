//
//  OpenAI+Manager.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import Foundation

final class OpenAIManager {
    static let shared = OpenAIManager()
    static let baseURL = "https://api.openai.com"
    static let openAIToken = "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"
    private init() { }
    
    private func createURL(path: String, queries: [String: String]?) -> URL {
        var components = URLComponents(string: Self.baseURL)!
        components.path = path
        components.queryItems = queries?.map({ URLQueryItem(name: $0.key, value: $0.value) })
        return components.url!
    }
    
    private func createRequest(url: URL, method: String, jsonBody: [String: Any]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let jsonBody = jsonBody {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
            } catch {
                print("Error serializing JSON: \(error)")
            }
        }
        
        return request
    }
    
    private func configureRequest<T: Decodable>(request: inout URLRequest, asType: T.Type?) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Self.openAIToken)", forHTTPHeaderField: "Authorization")
        if asType != nil {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, asType: T.Type?) throws -> T {
        if let error = error {
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        guard let responseData = data else {
            throw NetworkError.invalidData
        }
        
        if let dictResponse = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] {
            print("Dict Resp: \(dictResponse)")
        }

        do {
            if let responseType = asType {
                let decodedResponse = try JSONDecoder().decode(responseType, from: responseData)
                return decodedResponse
            } else {
                throw NetworkError.invalidResponseType
            }
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    private func performRequest<T: Decodable>(path: String, queries: [String: String]?, method: String, jsonBody: [String: Any]? = nil, asType: T.Type?) async throws -> T {
        let url = createURL(path: path, queries: queries)
        var request = createRequest(url: url, method: method, jsonBody: jsonBody)
        configureRequest(request: &request, asType: asType)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response, error: nil, asType: asType)
    }
    
    func get<T:Decodable>(_ path: String, queries: [String: String]? = nil, jsonBody: [String: Any]? = nil, asType: T.Type) async throws -> T {
        try await performRequest(path: path, queries: queries, method: "GET", jsonBody: jsonBody, asType: T.self)
    }
    
    func post<T:Decodable>(_ path: String, queries: [String: String]? = nil, jsonBody: [String: Any]? = nil, asType: T.Type) async throws -> T {
        try await performRequest(path: path, queries: queries, method: "POST", jsonBody: jsonBody, asType: T.self)
    }
    
    func postAudio(input: String) async throws -> Data {
        var urlRequest = URLRequest(url: URL(string: OpenAIManager.baseURL + "/v1/audio/speech")!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: [
            "model" : "tts-1",
            "input" : input,
            "voice" : "alloy"
        ])
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(OpenAIManager.openAIToken)", forHTTPHeaderField: "Authorization")
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
    
    
    /// .cdsc
    ///
    
    func getPredictionResult(input: String, completion: @escaping (String?, Error?) -> ()) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            completion(nil, OpenAIManagerError.urlError)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Self.openAIToken)", forHTTPHeaderField: "Authorization")
        let systemPrompt = "Your are a medical assistant. And you help people by answering their questions"
        let userPrompt = input
        let jsonBody: [ String : Any ] = [
            "model" : "gpt-3.5-turbo",
            "messages" : [
                [
                    "role" : "system",
                    "content" : systemPrompt
                ],
                [
                    "role" : "user",
                    "content" : userPrompt
                ]
            ]
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
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
                    let result = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
                    completion(result.choices?.first?.message?.content, nil)
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
    
    func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func sendAudio(audioFileURL: URL, model: String, completion: @escaping (String?, Error?) -> ()) {
        guard let url = URL(string: "https://api.openai.com/v1/audio/transcriptions/") else {
            print("Invalid URL")
            completion(nil, OpenAIManagerError.urlError)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set headers
        request.setValue("Bearer \(Self.openAIToken)", forHTTPHeaderField: "Authorization")

        // Create boundary for multipart/form-data
        let boundary = "----WebKitFormBoundary\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create the body of the request
        var body = Data()

        // Append audio file data to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        if let audioData = try? Data(contentsOf: audioFileURL) {
            body.append(audioData)
        } else {
            print("Failed to read audio file data")
            completion(nil, OpenAIManagerError.urlError)
            return
        }

        body.append("\r\n".data(using: .utf8)!)

        // Append model parameter
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; model=\"whisper-1\"\r\n\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; file=\"\(audioFileURL.absoluteString)\"\r\n\r\n".data(using: .utf8)!)
        // Append the closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        // Set the request body
        request.httpBody = body

        // Create a URLSession task to send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                completion(nil, error)
                return
            }

            // Check if a valid HTTP response was received
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let errorMessage = "Invalid HTTP response with status code \(statusCode)"
                completion(nil, OpenAIManagerError.urlError)
                return
            }

            // Check if there is data
            guard let responseData = data else {
                completion(nil, OpenAIManagerError.urlError)
                return
            }

            // Parse the data as needed
            if let resultString = String(data: responseData, encoding: .utf8) {
                // Successful response, call completion handler with result
                completion(resultString, nil)
            } else {
                // Unable to parse the data
                completion(nil, OpenAIManagerError.urlError)
            }
        }

        // Resume the task
        task.resume()
    }
}

// OPEN AI WITH TEXT GENERATION

struct WhisperResponse: Codable {
    let text: String
}

enum OpenAIManagerError: Error {
    case urlError
}


struct ChatGPTResponse: Codable {
    let id, object: String?
    let created: Int?
    let model: String?
    let usage: Usage?
    let choices: [Choice]?
}

// MARK: - Choice
struct Choice: Codable {
    let message: MessageOpenAI?
    let finishReason: String?
    let index: Int?
    
    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
        case index
    }
}

// MARK: - Message
struct MessageOpenAI: Codable {
    let role, content: String?
}

// MARK: - Usage
struct Usage: Codable {
    let promptTokens, completionTokens, totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct ModerateResponse: Codable {
    let id, model: String?
    let results: [Moderate]?
}

// MARK: - Result
struct Moderate: Codable {
    let flagged: Bool?
    let categoryScores: [String: Double]?
    let categories: [String: Bool]?
    
    enum CodingKeys: String, CodingKey {
        case flagged
        case categoryScores = "category_scores"
        case categories
    }
}
