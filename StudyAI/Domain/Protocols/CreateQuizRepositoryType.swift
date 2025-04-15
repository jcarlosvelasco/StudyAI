//
//  CreateQuizRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

protocol CreateQuizRepositoryType {
    func createQuiz(text: String, name: String, subjectID: UUID) async -> Result<Quiz, QuizDomainError>
}
