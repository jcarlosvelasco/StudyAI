//
//  LLMRepository.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

class LLMRepository:
    CreateQuizRepositoryType
{
    private let mapper: APIResponseMapper
    private let apiDataSource: APIDataSourceType
    private let errorMapper: QuizDomainErrorMapper
    
    init(
        mapper: APIResponseMapper,
        apiDataSource: APIDataSourceType,
        errorMapper: QuizDomainErrorMapper
    ) {
        self.mapper = mapper
        self.apiDataSource = apiDataSource
        self.errorMapper = errorMapper
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
