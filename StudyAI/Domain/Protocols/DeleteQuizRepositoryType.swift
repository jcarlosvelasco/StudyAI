//
//  DeleteQuizRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 6/4/25.
//

import Foundation

protocol DeleteQuizRepositoryType {
    func deleteQuiz(quizID: UUID) async -> Result<Void, QuizDomainError>
}
