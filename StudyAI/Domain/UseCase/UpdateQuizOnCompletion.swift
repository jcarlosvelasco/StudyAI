//
//  Update.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 7/4/25.
//

import Foundation

protocol UpdateQuizOnCompletionType {
    func execute(quizID: UUID, highScore: Int) async
}

class UpdateQuizOnCompletion: UpdateQuizOnCompletionType {
    private let updateQuizOnCompletionRepository: UpdateQuizOnCompletionRepositoryType
    
    init(updateQuizOnCompletionRepository: UpdateQuizOnCompletionRepositoryType) {
        self.updateQuizOnCompletionRepository = updateQuizOnCompletionRepository
    }
    
    func execute(quizID: UUID, highScore: Int) async {
        await updateQuizOnCompletionRepository.updateQuizOnCompletion(quizID: quizID, highScore: highScore)
    }
}
