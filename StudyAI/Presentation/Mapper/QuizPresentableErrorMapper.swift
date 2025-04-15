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
        }
    }
}
