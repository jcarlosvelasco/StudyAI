//
//  QuizMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

class QuizMapper {
    func mapQuizToQuizEntity(quiz: Quiz) -> QuizEntity {        
        let entity = QuizEntity(
            id: quiz.id,
            name: quiz.name,
            subjectID: quiz.subjectID,
            highestScore: quiz.highestScore,
            lastTimeCompleted: quiz.lastTimeCompleted,
            questions: []
        )
    
        var questions: [QuestionEntity] = []
        
        for question in quiz.questions {
            var options: [OptionEntity] = []
            for option in question.options {
                let option = OptionEntity(id: option.id, text: option.text)
                options.append(option)
            }
            questions.append(
                QuestionEntity(
                    id: question.id,
                    options: options,
                    correctOptionID: question.correctOptionID,
                    question: question.question
                )
            )
        }
        
        entity.questions = questions
        return entity
    }
}
