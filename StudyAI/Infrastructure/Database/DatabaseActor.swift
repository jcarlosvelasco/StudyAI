//
//  DatabaseActor.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/3/25.
//

import SwiftData
import Foundation

@ModelActor
actor DatabaseActor {
    func getSubjects() -> [SubjectEntity] {
        let descriptor = FetchDescriptor<SubjectEntity>(sortBy: [SortDescriptor(\.name)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching subjects: \(error)")
            return []
        }
    }
    
    func addSubject(subject: SubjectEntity) {
        print("Creating subject...")
        modelContext.insert(subject)
        do {
            try save()
        } catch {
            print("Error saving subject: \(error)")
        }
    }
    
    func getSubjectFromSubjectID(subjectID: UUID) async -> SubjectEntity? {
        var descriptor = FetchDescriptor<SubjectEntity>(predicate: #Predicate { subject in
            subject.id == subjectID
        })
        descriptor.fetchLimit = 1
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            fatalError("Error fetching subject: \(error)")
        }
    }
    
    func getQuizFromQuizID(quizID: UUID) async -> QuizEntity? {
        var descriptor = FetchDescriptor<QuizEntity>(predicate: #Predicate { quiz in
            quiz.id == quizID
        })
        descriptor.fetchLimit = 1
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            fatalError("Error fetching quiz: \(error)")
        }
    }
    
    func addDocumentToSubject(subjectID: UUID, documentURLString: String) async {
        let subject = await getSubjectFromSubjectID(subjectID: subjectID)
        if let subject = subject {
            for path in subject.filePaths {
                if path.name == documentURLString {
                    return
                }
            }
            
            subject.filePaths.append(FilePath(name: documentURLString))
            do {
                try save()
            }
            catch {
                print("Error saving document: \(error)")
            }
        }
    }
    
    func deleteSubject(subjectID: UUID) async {
        do {
            let subject = await getSubjectFromSubjectID(subjectID: subjectID)
            if let subject = subject {
                modelContext.delete(subject)
            }
            let quizzes = getQuizes(subjectID: subjectID)
            if let quizzes = quizzes {
                for quiz in quizzes {
                    modelContext.delete(quiz)
                }
            }
            try save()
        } catch {
            print("Error deleting subject: \(error)")
        }
    }
    
    func deleteDocumentFromSubject(subjectID: UUID, documentURLString: String) async {
        do {
            let subject = await getSubjectFromSubjectID(subjectID: subjectID)
            if let subject = subject {
                subject.filePaths.removeAll { $0.name == documentURLString }
                try save()
            }
        } catch {
            print("Error deleting document: \(error)")
        }
    }
    
    func storeQuiz(quiz: QuizEntity) async {
        modelContext.insert(quiz)
        do {
            try save()
        } catch {
            print("Error saving subject: \(error)")
        }
    }
    
    func getQuizes(subjectID: UUID) -> [QuizEntity]? {
        let predicate = #Predicate<QuizEntity> { $0.subjectID == subjectID }
        let descriptor = FetchDescriptor<QuizEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.name)]
        )
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching subjects: \(error)")
            return []
        }
    }
    
    func deleteQuiz(quizID: UUID) async {
        do {
            let quiz = await getQuizFromQuizID(quizID: quizID)
            if let quiz = quiz {
                modelContext.delete(quiz)
                try save()
            }
        } catch {
            print("Error deleting quiz: \(error)")
        }
    }
    
    func updateQuizOnCompletion(quizID: UUID, highScore: Int) async {
        do {
            guard let quiz = await getQuizFromQuizID(quizID: quizID) else {
                print("Quiz with ID \(quizID) not found.")
                return
            }
            
            quiz.highestScore = highScore
            quiz.lastTimeCompleted = Date()
            try save()
            print("Quiz updated")
        } catch {
            print("Error updating quiz: \(error.localizedDescription)")
        }
    }
    
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async {
        do {
            guard let subject = await getSubjectFromSubjectID(subjectID: subjectID) else {
                print("Subject with ID \(subjectID) not found.")
                return
            }
            
            let date = Date()
            subject.lastAIScoreUpdate = date
            subject.score = score
            subject.scoreText = scoreText
            try save()
            print("Updated subject score with new Date: \(date.description)")
        } catch {
            print("Error updating subject: \(error.localizedDescription)")
        }
    }
    
    func save() throws {
        try modelContext.save()
    }
}
