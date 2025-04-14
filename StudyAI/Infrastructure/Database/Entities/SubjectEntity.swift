//
//  SubjectEntity.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 22/3/25.
//

import Foundation
import SwiftData

@Model
class SubjectEntity {
    var id = UUID()
    var name: String
    
    var filePaths: [FilePath] = []
    var score: Int = 0
    var scoreText: String? = nil
    var lastAIScoreUpdate: Date? = nil
    
    init(
        id: UUID,
        name: String,
        filePaths: [FilePath],
        score: Int,
        scoreText: String?,
        lastAIScoreUpdate: Date?
    ) {
        self.name = name
        self.id = id
        self.filePaths = filePaths
        self.score = score
        self.scoreText = scoreText
        self.lastAIScoreUpdate = lastAIScoreUpdate
    }
}


struct FilePath: Codable {
    let name: String
}
