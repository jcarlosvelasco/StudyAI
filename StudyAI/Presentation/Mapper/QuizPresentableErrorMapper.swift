//
//  QuizPresentableErrorMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

class QuizPresentableErrorMapper {
    func map(error: QuizDomainError?) -> String {
        guard let error = error else {
            return "Something went wrong"
        }
        
        switch error {
            case .generic:
                return "Something went wrong"
            case .tooManyRequests:
                return "Too many requests. Please try again later."
            case .databaseError:
                return "Database error. Please try again later."
        }
    }
}
