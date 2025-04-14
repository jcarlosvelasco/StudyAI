//
//  QuizRepository.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

import Foundation

class QuizRepository:
    StoreQuizRepositoryType,
    GetQuizesRepositoryType,
    DeleteQuizRepositoryType,
    UpdateQuizOnCompletionRepositoryType
{
    private let quizMapper: QuizMapper
    private let quizEntityMapper: QuizEntityMapper
    private let database: DatabaseInfrastructureType
    
    init(
        quizMapper: QuizMapper,
        database: DatabaseInfrastructureType,
        quizEntityMapper: QuizEntityMapper
    ) {
        self.quizMapper = quizMapper
        self.database = database
        self.quizEntityMapper = quizEntityMapper
    }
    
    func storeQuiz(quiz: Quiz) async {
        let entity = quizMapper.mapQuizToQuizEntity(quiz: quiz)
        await database.storeQuiz(quiz: entity)
    }
    
    func getQuizes(subjectID: UUID) async -> [Quiz]? {
        let entities = await database.getQuizes(subjectID: subjectID)
        guard let entities else { return nil }
        return entities.map { quizEntityMapper.mapToQuiz(entity: $0) }
    }
    
    func deleteQuiz(quizID: UUID) async {
        await database.deleteQuiz(quizID: quizID)
    }
    
    func updateQuizOnCompletion(quizID: UUID, highScore: Int) async {
        await database.updateQuizOnCompletion(quizID: quizID, highScore: highScore)
    }
}
