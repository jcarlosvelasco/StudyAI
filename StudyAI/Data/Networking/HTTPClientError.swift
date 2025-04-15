//
//  HTTPClientError.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//


enum HTTPClientError: Error {
    case generic
    case tooManyRequests
    case serverError
    case clientError
    case badURL
    case responseError
    case parsingError
}
