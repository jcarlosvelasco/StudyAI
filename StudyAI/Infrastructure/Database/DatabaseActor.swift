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
    
    func addSubject(subject: SubjectEntity) async -> Result<Void, DatabaseError> {
        do {
            modelContext.insert(subject)
            try modelContext.save()
            return .success(())
        } catch {
            Logger.log(.error, "Error saving subject: \(error)")
            return .failure(.generic)
        }
    }
    
    func getSubjectFromSubjectID(subjectID: UUID) async -> Result<SubjectEntity?, DatabaseError> {
        var descriptor = FetchDescriptor<SubjectEntity>(predicate: #Predicate { subject in
            subject.id == subjectID
        })
        descriptor.fetchLimit = 1
        
        do {
            let result = try modelContext.fetch(descriptor).first
            return .success(result)
        } catch {
            Logger.log(.error, "Error fetching subject: \(error)")
            return .failure(.generic)
        }
    }
    
    func getQuizFromQuizID(quizID: UUID) async -> Result<QuizEntity?, DatabaseError> {
        var descriptor = FetchDescriptor<QuizEntity>(predicate: #Predicate { quiz in
            quiz.id == quizID
        })
        descriptor.fetchLimit = 1
        
        do {
            let result = try modelContext.fetch(descriptor).first
            return .success(result)
        } catch {
            Logger.log(.error, "Error fetching quiz: \(error)")
            return .failure(.generic)
        }
    }
    
    func addDocumentToSubject(subjectID: UUID, documentURLString: String) async -> Result<Void, DatabaseError> {
        let result = await getSubjectFromSubjectID(subjectID: subjectID)
        guard case .success(let subject) = result else {
            guard case .failure(let failure) = result else {
                return .failure(.generic)
            }
            return .failure(failure)
        }
        
        if let subject = subject {
            if subject.filePaths.contains(where: {$0.name == documentURLString}) {
                return .success(())
            }
            
            subject.filePaths.append(FilePath(name: documentURLString))
            do {
                try modelContext.save()
                return .success(())
            }
            catch {
                Logger.log(.error, "Error saving document: \(error)")
                return .failure(.generic)
            }
        }
        
        return .success(())
    }
    
    func deleteSubject(subjectID: UUID) async -> Result<Void, DatabaseError> {
        let result = await getSubjectFromSubjectID(subjectID: subjectID)
        guard case .success(let subject) = result else {
            guard case .failure(let failure) = result else {
                return .failure(.generic)
            }
            return .failure(failure)
        }
        
        if let subject = subject {
            do {
                modelContext.delete(subject)
                let quizzesResult = await getQuizes(subjectID: subjectID)
                guard case .success(let quizzes) = quizzesResult else {
                    guard case .failure(let failure) = quizzesResult else {
                        return .failure(.generic)
                    }
                    return .failure(failure)
                }
                
                for quiz in quizzes {
                    modelContext.delete(quiz)
                }
                
                try modelContext.save()
                return .success(())
            } catch {
                Logger.log(.error, "Error deleting subject: \(error)")
                return .failure(.generic)
            }
        }
        
        return .success(())
    }
    
    func deleteDocumentFromSubject(subjectID: UUID, documentURLString: String) async -> Result<Void, DatabaseError> {
        let result = await getSubjectFromSubjectID(subjectID: subjectID)
        guard case .success(let subject) = result else {
            guard case .failure(let failure) = result else {
                return .failure(.generic)
            }
            return .failure(failure)
        }
        
        if let subject = subject {
            subject.filePaths.removeAll { $0.name == documentURLString }
            do {
                try modelContext.save()
                return .success(())
            } catch {
                Logger.log(.error, "Error deleting document: \(error)")
                return .failure(.generic)
            }
        }
        
        return .success(())
    }
    
    func storeQuiz(quiz: QuizEntity) async -> Result<Void, DatabaseError> {
        do {
            modelContext.insert(quiz)
            try modelContext.save()
            return .success(())
        } catch {
            Logger.log(.error, "Error saving quiz: \(error)")
            return .failure(.generic)
        }
    }
    
    func getQuizes(subjectID: UUID) async -> Result<[QuizEntity], DatabaseError> {
        let predicate = #Predicate<QuizEntity> { $0.subjectID == subjectID }
        let descriptor = FetchDescriptor<QuizEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.name)]
        )
        do {
            let result = try modelContext.fetch(descriptor)
            return .success(result)
        } catch {
            Logger.log(.error, "Error fetching quizzes: \(error)")
            return .failure(.generic)
        }
    }
    
    func deleteQuiz(quizID: UUID) async -> Result<Void, DatabaseError> {
        let result = await getQuizFromQuizID(quizID: quizID)
        
        switch result {
            case .failure(let error):
                return .failure(error)
            case .success(nil):
                return .success(())
            case .success(let quiz?):
                do {
                    modelContext.delete(quiz)
                    try modelContext.save()
                    return .success(())
                } catch {
                    Logger.log(.error, "Error deleting quiz: \(error)")
                    return .failure(.generic)
                }
            }
    }
    
    func updateQuizOnCompletion(quizID: UUID, highScore: Int, selectedOptionsIDs: [UUID]) async -> Result<Void, DatabaseError> {
        let result = await getQuizFromQuizID(quizID: quizID)
        guard case .success(let quiz) = result else {
            guard case .failure(let failure) = result else {
                return .failure(.generic)
            }
            return .failure(failure)
        }
        
        if let quiz = quiz {
            quiz.highestScore = highScore
            quiz.lastTimeCompleted = Date()
            
            for i in 0..<quiz.questions.count {
                quiz.questions[i].selectedOptionID = selectedOptionsIDs[i]
            }
            
            do {
                try modelContext.save()
                Logger.log(.info, "Updated quiz")
                return .success(())
            } catch {
                Logger.log(.error, "Error updating quiz: \(error.localizedDescription)")
                return .failure(.generic)
            }
        }
        
        return .success(())
    }
    
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async -> Result<Void, DatabaseError> {
        let result = await getSubjectFromSubjectID(subjectID: subjectID)
        guard case .success(let subject) = result else {
            guard case .failure(let failure) = result else {
                return .failure(.generic)
            }
            return .failure(failure)
        }
        
        if let subject = subject {
            let date = Date()
            subject.lastAIScoreUpdate = date
            subject.score = score
            subject.scoreText = scoreText
            
            do {
                try modelContext.save()
                Logger.log(.info, "Updated subject score with new Date: \(date.description)")
                return .success(())
            } catch {
                Logger.log(.error, "Error updating subject: \(error.localizedDescription)")
                return .failure(.generic)
            }
        }
        
        return .success(())
    }
}
