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
    UpdateQuizOnCompletionRepositoryType,
    CreateQuizRepositoryType
{
    private let quizMapper: QuizMapper
    private let quizEntityMapper: QuizEntityMapper
    private let database: DatabaseInfrastructureType
    private let mapper: APIResponseMapper
    private let apiDataSource: APIDataSourceType
    private let errorMapper: QuizDomainErrorMapper
    
    init(
        quizMapper: QuizMapper,
        database: DatabaseInfrastructureType,
        quizEntityMapper: QuizEntityMapper,
        mapper: APIResponseMapper,
        apiDataSource: APIDataSourceType,
        errorMapper: QuizDomainErrorMapper
    ) {
        self.quizMapper = quizMapper
        self.database = database
        self.quizEntityMapper = quizEntityMapper
        self.mapper = mapper
        self.apiDataSource = apiDataSource
        self.errorMapper = errorMapper
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
    
    func createQuiz(text: String, name: String, subjectID: UUID) async -> Result<Quiz, QuizDomainError> {
        print("LLM Repository, createQuiz")
        
        let result = await apiDataSource.sendMessageToLLM(text: text)
        guard case .success(let response) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }

        let quiz = mapper.mapToQuiz(response: response, name: name, subjectID: subjectID)
        
        guard let quiz = quiz else {
            return .failure(.generic)
        }
        
        return .success(quiz)
    }
}
