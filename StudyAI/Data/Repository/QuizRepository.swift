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
    
    func storeQuiz(quiz: Quiz) async -> Result<Void, QuizDomainError> {
        let entity = quizMapper.mapQuizToQuizEntity(quiz: quiz)
        let result = await database.storeQuiz(quiz: entity)
        guard case .success() = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(())
    }
    
    func getQuizes(subjectID: UUID) async -> Result<[Quiz], QuizDomainError> {
        let result = await database.getQuizes(subjectID: subjectID)
        guard case .success(let entities) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        
        let quizzes = entities.map { quizEntityMapper.mapToQuiz(entity: $0) }
        return .success(quizzes)
    }
    
    func deleteQuiz(quizID: UUID) async -> Result<Void, QuizDomainError> {
        let result = await database.deleteQuiz(quizID: quizID)
        guard case .success() = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(())
    }
    
    func updateQuizOnCompletion(quizID: UUID, highScore: Int) async -> Result<Void, QuizDomainError> {
        let result = await database.updateQuizOnCompletion(quizID: quizID, highScore: highScore)
        guard case .success() = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(())
    }
    
    func createQuiz(text: String, name: String, subjectID: UUID) async -> Result<Quiz, QuizDomainError> {        
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
