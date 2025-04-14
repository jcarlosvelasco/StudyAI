//
//  Subject.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//

import Foundation

class Subject {
    let id: UUID
    var name: String
    let fileURLs: [URL]
    let quizs: [Quiz] = []
    var score: Int = 0
    var scoreText: String? = nil
    var lastAIScoreUpdate: Date? = nil
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.fileURLs = []
    }
    
    init(
        id: UUID,
        name: String,
        fileURLs: [URL],
        score: Int,
        lastAIScoreUpdate: Date?,
        scoreText: String?
    ) {
        self.id = id;
        self.name = name;
        self.fileURLs = fileURLs
        self.lastAIScoreUpdate = lastAIScoreUpdate
        self.scoreText = scoreText
        self.score = score
    }
}
