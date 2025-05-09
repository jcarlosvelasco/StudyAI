//
//  QuizDomainErrorMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

class QuizDomainErrorMapper {
    func map(error: HTTPClientError?) -> QuizDomainError {
        switch error {
            case .tooManyRequests:
                return .tooManyRequests
            default:
                return .generic
        }
    }
    
    func map(error: DatabaseError?) -> QuizDomainError {
        switch error {
            case .generic:
                return .databaseError
            default:
                return .databaseError
        }
    }
}
