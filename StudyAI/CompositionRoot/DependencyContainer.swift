//
//  DependencyContainer.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/3/25.
//

import SwiftData

final class DependencyContainer {
    static let shared = DependencyContainer()
    let modelContainer: ModelContainer
    
    private init() {
        do {
            modelContainer = try ModelContainer(for: SubjectEntity.self, QuizEntity.self, QuestionEntity.self, OptionEntity.self)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
