//
//  QuizEntityMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

class QuizEntityMapper {
    func mapToQuiz(entity: QuizEntity) -> Quiz {        
        let quiz = Quiz(
            id: entity.id,
            name: entity.name,
            questions: [],
            subjectID: entity.subjectID,
            highestScore: entity.highestScore,
            lastTimeCompleted: entity.lastTimeCompleted
        )
        
        var questions: [Question] = []
        
        for questionEntity in entity.questions {
            var options: [Option] = []
            for optionEntity in questionEntity.options {
                let option = Option(id: optionEntity.id, text: optionEntity.text)
                options.append(option)
            }
            questions.append(
                Question(
                    id: questionEntity.id,
                    options: options,
                    correctOptionID: questionEntity.correctOptionID,
                    question: questionEntity.question,
                    selectedOptionID: questionEntity.selectedOptionID
                )
            )
        }
        
        quiz.questions = questions
        
        return quiz
    }
}
