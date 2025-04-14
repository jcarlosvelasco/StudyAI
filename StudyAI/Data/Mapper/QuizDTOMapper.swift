//
//  QuizMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

class QuizDTOMapper {
    func mapQuizDTOToQuiz(dto: QuizDTO, name: String, subjectID: UUID) -> Quiz? {
        let quiz = Quiz(name: name, subjectID: subjectID)
                
        for question in dto.questions {
            var options = [Option]()
            
            for option in question.options {
                let option = Option(text: option)
                options.append(option)
            }
            
            let correctOptionID = options.first { option in
                option.text == question.correctAnswer
            }?.id
            
            if correctOptionID == nil {
                continue
            }
            
            quiz.questions.append(
                Question(options: options, correctOptionID: correctOptionID!, question: question.question)
            )
        }

        return quiz
    }
}
