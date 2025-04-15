//
//  SubjectPresentableErrorMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

class SubjectPresentableErrorMapper {
    func map(error: SubjectDomainError?) -> String {
        guard let error = error else {
            return "Something went wrong"
        }
        
        switch error {
            case .generic:
                return "Something went wrong"
        }
    }
}
