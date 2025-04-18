//
//  StoreQuiz.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

protocol StoreQuizType {
    func execute(quiz: Quiz) async -> Result<Void, QuizDomainError>
}

class StoreQuiz: StoreQuizType {
    private let storeQuizRepository: StoreQuizRepositoryType
    
    init(storeQuizRepository: StoreQuizRepositoryType) {
        self.storeQuizRepository = storeQuizRepository
    }
    
    func execute(quiz: Quiz) async -> Result<Void, QuizDomainError> {
        await storeQuizRepository.storeQuiz(quiz: quiz)
    }
}
