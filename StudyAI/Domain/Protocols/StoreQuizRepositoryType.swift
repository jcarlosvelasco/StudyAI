//
//  StoreQuizRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

protocol StoreQuizRepositoryType {
    func storeQuiz(quiz: Quiz) async -> Result<Void, QuizDomainError>
}
