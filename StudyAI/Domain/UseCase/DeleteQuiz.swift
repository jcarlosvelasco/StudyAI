//
//  DeleteQuiz.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 6/4/25.
//

import Foundation

protocol DeleteQuizType {
    func execute(quizID: UUID) async -> Result<Void, QuizDomainError>
}

class DeleteQuiz: DeleteQuizType {
    private let deleteQuizRepository: DeleteQuizRepositoryType
    
    init(deleteQuizRepository: DeleteQuizRepositoryType) {
        self.deleteQuizRepository = deleteQuizRepository
    }
    
    func execute(quizID: UUID) async -> Result<Void, QuizDomainError> {
        return await deleteQuizRepository.deleteQuiz(quizID: quizID)
    }
}
