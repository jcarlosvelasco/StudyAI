//
//  GetQuizes.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

import Foundation

protocol GetQuizesType {
    func execute(subjectID: UUID) async -> [Quiz]
}

class GetQuizes: GetQuizesType {
    private let getQuizesRepository: GetQuizesRepositoryType
    
    init(getQuizesRepository: GetQuizesRepositoryType) {
        self.getQuizesRepository = getQuizesRepository
    }
    
    func execute(subjectID: UUID) async -> [Quiz] {
        let value = await getQuizesRepository.getQuizes(subjectID: subjectID)
        guard let value = value else {
            return []
        }
        return value
    }
}
