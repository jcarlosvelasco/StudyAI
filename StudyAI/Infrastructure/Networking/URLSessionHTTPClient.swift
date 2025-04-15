//
//  URLSessionHTTPClient.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 14/4/25.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let requestMaker: URLSessionRequestMaker
    private let errorResolver: URLSessionErrorResolver
    
    init(
        session: URLSession = .shared,
        requestMaker: URLSessionRequestMaker,
        errorResolver: URLSessionErrorResolver
    ) {
        self.session = session
        self.requestMaker = requestMaker
        self.errorResolver = errorResolver
    }
    
    func makeRequest(endpoint: Endpoint, baseUrl: String) async -> Result<Data, HTTPClientError> {
        guard let url = requestMaker.url(endpoint: endpoint, baseURL: baseUrl) else {
            return .failure(.badURL)
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue.uppercased()
            
            for (key, value) in endpoint.headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            if let body = endpoint.body {
                request.httpBody = body
            }

            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.responseError)
            }
            
            guard response.statusCode == 200 else {
                return .failure(errorResolver.resolve(statusCode: response.statusCode))
            }
            
            return .success(data)
        }
        catch {
            return .failure(errorResolver.resolver(error: error))
        }
    }
}
