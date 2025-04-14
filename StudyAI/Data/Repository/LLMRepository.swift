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
    private let llm: LLMInfrastructureType
    private let mapper: APIResponseMapper
    
    init(
        llm: LLMInfrastructureType,
        mapper: APIResponseMapper
    ) {
        self.llm = llm
        self.mapper = mapper
    }
    
    func createQuiz(text: String, name: String, subjectID: UUID) async -> Quiz? {
        print("LLM Repository, createQuiz")
        let quiz = await llm.sendMessage(text: text)
        guard let quiz else { return nil }
        return mapper.mapAPIResponseToQuiz(response: quiz, name: name, subjectID: subjectID)
    }
}
