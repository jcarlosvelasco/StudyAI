//
//  APIDataSource.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 14/4/25.
//

import Foundation

class APIDataSource: APIDataSourceType {
    private let httpClient: HTTPClient
    private let requestBuilder: RequestBuilder
    
    init(
        httpClient: HTTPClient,
        requestBuilder: RequestBuilder
    ) {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
    }
    
    func sendMessageToLLM(text: String) async -> Result<APIResponse, HTTPClientError> {
        let baseURL = "https://openrouter.ai/api/v1"
        let model = "google/gemini-2.0-flash-exp:free"
        
        let requestBody = requestBuilder.buildRequest(model: model, text: text)
        
        let headers = [
            "Authorization": "Bearer \(ApiKeys.openRouterKey)",
            "Content-Type": "application/json"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            let endpoint = Endpoint(
                path: "/chat/completions",
                method: HTTPMethod.post,
                headers: headers,
                body: jsonData
            )
            
            let result = await httpClient.makeRequest(endpoint: endpoint, baseUrl: baseURL)
            
            guard case .success(let data) = result else {
                guard case .failure(let error) = result else {
                    return .failure(.generic)
                }
                return .failure(error)
            }
            
            guard let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else {
                return .failure(.parsingError)
            }
            
            return .success(apiResponse)
        }
        catch {
            return .failure(.generic)
        }
    }
    
    private func handleError(error: HTTPClientError?) -> HTTPClientError {
        guard let error = error else {
            return .generic
        }
        return error
    }
}
