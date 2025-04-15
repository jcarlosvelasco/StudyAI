//
//  MapperModule.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

import Factory

extension Container {
    var quizPresentableErrorMapper: Factory<QuizPresentableErrorMapper> {
        self {
            QuizPresentableErrorMapper()
        }
        .singleton
    }
    
    var subjectPresentableErrorMapper: Factory<SubjectPresentableErrorMapper> {
        self {
            SubjectPresentableErrorMapper()
        }
        .singleton
    }
}
