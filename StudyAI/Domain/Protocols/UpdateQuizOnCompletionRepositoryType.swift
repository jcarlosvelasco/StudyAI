//
//  UpdateQuizOnCompletionRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 7/4/25.
//

import Foundation

protocol UpdateQuizOnCompletionRepositoryType {
    func updateQuizOnCompletion(quizID: UUID, highScore: Int, selectedOptionsIDs: [UUID]) async -> Result<Void, QuizDomainError>
}
