//
//  URLSessionErrorResolver.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

class URLSessionErrorResolver {
    func resolve(statusCode: Int) -> HTTPClientError {
        guard statusCode != 429 else {
            return .tooManyRequests
        }
        
        guard statusCode < 500 else {
            return .clientError
        }
        
        return .serverError
    }
    
    func resolver(error: Error) -> HTTPClientError {
        return .generic
    }
}
