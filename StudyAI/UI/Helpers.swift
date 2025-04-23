//
//  Helpers.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

class Helpers {
    static func createSampleOptions() -> [Option] {
        return [
            Option(text: "Option 1"),
            Option(text: "Option 2"),
            Option(text: "Option 3"),
            Option(text: "Option 4")
        ]
    }

    static func createSampleQuestions() -> [Question] {
        let options1 = createSampleOptions()
        let options2 = createSampleOptions()
        
        return [
            Question(options: options1, correctOptionID: options1[1].id, question: "Question", selectedOptionID: options1[2].id),
            Question(options: options2, correctOptionID: options2[3].id, question: "Question", selectedOptionID: options1[3].id)
        ]
    }

    static func createSampleQuiz() -> Quiz {
        let quiz = Quiz(name: "Sample Quiz", subjectID: UUID())
        quiz.questions = createSampleQuestions()
        return quiz
    }
}
