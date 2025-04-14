//
//  StudyAIApp.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//

import SwiftUI
import SwiftData

@main
struct StudyAIApp: App {
    private let dependencies = DependencyContainer.shared

    var body: some Scene {        
        WindowGroup {
            SubjectsView(
                subjectsVM: SubjectsViewModel()
            )
        }
        .modelContainer(dependencies.modelContainer)
    }
}
