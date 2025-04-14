//
//  MapperModule.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/3/25.
//

import Factory

extension Container {
    var getSubjectEntityMapper: Factory<SubjectEntityMapper> {
        self {
            SubjectEntityMapper()
        }
        .singleton
    }
    
    var getSubjectMapper: Factory<SubjectMapper> {
        self {
            SubjectMapper()
        }
        .singleton
    }
    
    var apiResponseMapper: Factory<APIResponseMapper> {
        self {
            APIResponseMapper(quizDTOMapper: self.quizDTOMapper())
        }
        .singleton
    }
    
    var quizDTOMapper: Factory<QuizDTOMapper> {
        self {
            QuizDTOMapper()
        }
        .singleton
    }
    
    var quizMapper: Factory<QuizMapper> {
        self {
            QuizMapper()
        }
        .singleton
    }
    
    var quizEntityMapper: Factory<QuizEntityMapper> {
        self {
            QuizEntityMapper()
        }
        .singleton
    }
}
