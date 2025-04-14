//
//  LLM.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 27/3/25.
//

import Foundation

class LLMInfrastructure: LLMInfrastructureType {
    private let model = "google/gemini-2.0-flash-exp:free"
    private let baseURL = "https://openrouter.ai/api/v1/chat/completions"
    
    func sendMessage(text: String) async -> APIResponse? {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(ApiKeys.openRouterKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": text
                        ]
                    ]
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            let decoder = JSONDecoder()
            print(response)
            print(data)
            return try decoder.decode(APIResponse.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func sendText(text: String) async -> APIResponse? {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(ApiKeys.openRouterKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": text
                        ]
                    ]
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            let decoder = JSONDecoder()
            print(data)
            return try decoder.decode(APIResponse.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}

