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
    func getSubjects() async -> Result<[SubjectEntity], DatabaseError> {
        let descriptor = FetchDescriptor<SubjectEntity>(sortBy: [SortDescriptor(\.name)])
        do {
            let result = try modelContext.fetch(descriptor)
            return .success(result)
        } catch {
            Logger.log(.error, "Error fetching subjects: \(error)")
            return .failure(.generic)
        }
    }
    
    func addSubject(subject: SubjectEntity) {
        modelContext.insert(subject)
        do {
            try save()
        } catch {
            Logger.log(.error, "Error saving subject: \(error)")
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
            Logger.log(.error, "Error fetching subject: \(error)")
            return nil
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
            Logger.log(.error, "Error fetching quiz: \(error)")
            return nil
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
                Logger.log(.error, "Error saving document: \(error)")
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
            Logger.log(.error, "Error deleting subject: \(error)")
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
            Logger.log(.error, "Error deleting document: \(error)")
        }
    }
    
    func storeQuiz(quiz: QuizEntity) async {
        modelContext.insert(quiz)
        do {
            try save()
        } catch {
            Logger.log(.error, "Error saving quiz: \(error)")
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
            Logger.log(.error, "Error fetching quizzes: \(error)")
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
            Logger.log(.error, "Error deleting quiz: \(error)")
        }
    }
    
    func updateQuizOnCompletion(quizID: UUID, highScore: Int) async {
        do {
            guard let quiz = await getQuizFromQuizID(quizID: quizID) else {
                Logger.log(.warning, "Quiz with ID \(quizID) not found.")
                return
            }
            
            quiz.highestScore = highScore
            quiz.lastTimeCompleted = Date()
            try save()
            Logger.log(.info, "Updated quiz")
        } catch {
            Logger.log(.error, "Error updating quiz: \(error.localizedDescription)")
        }
    }
    
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async {
        do {
            guard let subject = await getSubjectFromSubjectID(subjectID: subjectID) else {
                Logger.log(.warning, "Subject with ID \(subjectID) not found.")
                return
            }
            
            let date = Date()
            subject.lastAIScoreUpdate = date
            subject.score = score
            subject.scoreText = scoreText
            try save()
            Logger.log(.info, "Updated subject score with new Date: \(date.description)")
        } catch {
            Logger.log(.error, "Error updating subject: \(error.localizedDescription)")
        }
    }
    
    func save() throws {
        try modelContext.save()
    }
}
