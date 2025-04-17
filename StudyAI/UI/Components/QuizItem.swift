//
//  QuizItem.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 6/4/25.
//

import SwiftUI

struct QuizItem: View {
    private let quiz: Quiz
    private var onDelete: () -> Void
    
    init(
        quiz: Quiz,
        onDelete: @escaping () -> Void
    ) {
        self.quiz = quiz
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(quiz.name).bold()
                Text("Highest score: \(quiz.highestScore) / \(quiz.questions.count)").foregroundStyle(.secondary)
            }
            Spacer()
            if quiz.highestScore == quiz.questions.count {
                Text("🏆")
            }
        }
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct QuizItem_Previews: PreviewProvider {
    static var previews: some View {
        QuizItem(
            quiz: Quiz(name: "a", subjectID: UUID()), onDelete: {}
        )
    }
}
