//
//  GetQuizes.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

import Foundation

protocol GetQuizesType {
    func execute(subjectID: UUID) async -> Result<[Quiz], QuizDomainError>
}

class GetQuizes: GetQuizesType {
    private let getQuizesRepository: GetQuizesRepositoryType
    
    init(getQuizesRepository: GetQuizesRepositoryType) {
        self.getQuizesRepository = getQuizesRepository
    }
    
    func execute(subjectID: UUID) async -> Result<[Quiz], QuizDomainError> {
        let result = await getQuizesRepository.getQuizes(subjectID: subjectID)
        guard case .success(let quizzes) = result else {
            if case .failure(let error) = result {
                return .failure(error)
            } else {
                return .failure(.generic)
            }
        }
        
        return .success(quizzes)
    }
}
