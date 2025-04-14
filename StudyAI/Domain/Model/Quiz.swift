//
//  Quiz.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 27/3/25.
//

import Foundation

class Quiz {
    var id: UUID
    let name: String
    let subjectID: UUID
    var questions: [Question]
    var highestScore: Int = 0
    var lastTimeCompleted: Date?
    
    init(
        id: UUID,
        name: String,
        questions: [Question],
        subjectID: UUID,
        highestScore: Int,
        lastTimeCompleted: Date?
    ) {
        self.id = id
        self.name = name
        self.questions = questions
        self.subjectID = subjectID
        self.highestScore = highestScore
        self.lastTimeCompleted = lastTimeCompleted
    }
    
    init(name: String, subjectID: UUID) {
        self.name = name
        self.id = UUID()
        self.questions = []
        self.subjectID = subjectID
    }
}
