//
//  GetAIScoreRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 12/4/25.
//

protocol GetAIScoreRepositoryType {
    func getAIScore(text: String) async -> String?
}
