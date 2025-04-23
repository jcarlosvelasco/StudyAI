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
            text += "\n\nQuiz \(quiz.id.uuidString): "
            for question in quiz.questions {
                text += question.question
                text += "\nOptions: "
                for option in question.options {
                    text += "{id: \(option.id.uuidString), option: \(option.text)}"
                }
                text += "\nCorrect option id: \(question.correctOptionID.uuidString)"
                text += "\nSelected option id: \(question.selectedOptionID?.uuidString ?? "None")"
            }
        }
        let prompt = PromptConfig.aiScorePrompt(locale: locale, quizzesText: text, score: score)
        return await getAIScoreTextRepo.getAIScore(text: prompt)
        //return .success("A")
    }
}
