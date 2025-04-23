//
//  Question.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 27/3/25.
//

import Foundation

class Question {
    let id: UUID
    let question: String
    let options: [Option]
    let correctOptionID: UUID
    let selectedOptionID: UUID?
    
    init(
        id: UUID = UUID(),
        options: [Option],
        correctOptionID: UUID,
        question: String,
        selectedOptionID: UUID?
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.correctOptionID = correctOptionID
        self.selectedOptionID = selectedOptionID
    }
}
