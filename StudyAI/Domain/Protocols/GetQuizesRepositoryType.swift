//
//  GetQuizesRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

import Foundation

protocol GetQuizesRepositoryType {
    func getQuizes(subjectID: UUID) async -> Result<[Quiz], QuizDomainError>
}
