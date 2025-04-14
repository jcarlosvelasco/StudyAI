//
//  QuizEntity.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

import Foundation
import SwiftData

@Model
class QuizEntity {
    var id = UUID()
    var name: String
    var subjectID: UUID
    var questions: [QuestionEntity]
    var highestScore: Int = 0
    var lastTimeCompleted: Date?
    
    init(
        id: UUID,
        name: String,
        subjectID: UUID,
        highestScore: Int,
        lastTimeCompleted: Date?,
        questions: [QuestionEntity]
    ) {
        self.id = id
        self.name = name
        self.questions = questions
        self.subjectID = subjectID
        self.lastTimeCompleted = lastTimeCompleted
    }
}


@Model
class QuestionEntity {
    var id: UUID
    var question: String
    var options: [OptionEntity]
    var correctOptionID: UUID
    
    init(
        id: UUID,
        options: [OptionEntity],
        correctOptionID: UUID,
        question: String
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.correctOptionID = correctOptionID
    }
}

@Model
class OptionEntity {
    var id: UUID
    var text: String
    
    init(
        id: UUID,
        text: String
    ) {
        self.id = id
        self.text = text
    }
}
