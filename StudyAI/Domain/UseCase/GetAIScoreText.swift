//
//  GetAIScoreText.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 12/4/25.
//

import Foundation

protocol GetAIScoreTextType {
    func execute(score: Int, quizzes: [Quiz]) async -> Result<String, SubjectDomainError>
}

class GetAIScore: GetAIScoreTextType {
    private let getAIScoreTextRepo: GetAIScoreRepositoryType
    private let locale: String
    
    init(getAIScoreTextRepo: GetAIScoreRepositoryType) {
        self.getAIScoreTextRepo = getAIScoreTextRepo
        if #available(iOS 16.0, *) {
            locale = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            locale = Locale.current.languageCode ?? "en"
        }
    }
    
    func execute(score: Int, quizzes: [Quiz]) async -> Result<String, SubjectDomainError> {        
        var text = ""
        for quiz in quizzes {
            text += "\n\nQuiz \(quiz.id): "
            for question in quiz.questions {
                text += question.question
                text += "\nOptions: "
                for option in question.options {
                    text += "{id: \(option.id), option: \(option.text)}"
                }
                text += "\nCorrect option id: \(question.correctOptionID)"
            }
        }
        
        let fullPrompt = #"""
            I have the following quizzes: \#(quizzes). Based on the correct options, i have a score of \#(score) out of 100. Based on the questions and on my score, could you give me a text (2 sentences max) that sums up the score and helps me improve my score by focusing on the parts I need to improve? Your answer must be in the language: \#(locale). If you don't support that language, fallback to English. Please only provide the answer.
            """#
        return await getAIScoreTextRepo.getAIScore(text: fullPrompt)
    }
}
