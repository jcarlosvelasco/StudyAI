//
//  SubjectEntityMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 22/3/25.
//

import Foundation

class SubjectEntityMapper {
    func mapToSubject(entity: SubjectEntity) -> Subject {
        return Subject(
            id: entity.id,
            name: entity.name,
            fileURLs: entity.filePaths.map { URL(string: $0.name)! },
            score: entity.score,
            lastAIScoreUpdate: entity.lastAIScoreUpdate,
            scoreText: entity.scoreText
        )
    }
}
