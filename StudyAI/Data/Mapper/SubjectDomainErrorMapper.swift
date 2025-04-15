//
//  SubjectDomainErrorMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

class SubjectDomainErrorMapper {
    func map(error: HTTPClientError?) -> SubjectDomainError {
        switch error {
            case .tooManyRequests:
                return .tooManyRequests
            default:
                return .generic
        }
    }
}
