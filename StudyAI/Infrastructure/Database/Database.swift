//
//  Database.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 22/3/25.
//

import SwiftData
import Foundation

class Database: DatabaseInfrastructureType {
    private let actor: DatabaseActor
    
    init(modelContainer: ModelContainer) {
        self.actor = DatabaseActor(modelContainer: modelContainer)
    }
    
    func getSubjects() async -> Result<[SubjectEntity], DatabaseError> {
        await actor.getSubjects()
    }
    
    func addSubject(subject: SubjectEntity) async -> Result<Void, DatabaseError> {
        await actor.addSubject(subject: subject)
    }
    
    func addDocumentURLToSubject(subjectID: UUID, documentURLString: String) async -> Result<Void, DatabaseError> {
        await actor.addDocumentToSubject(subjectID: subjectID, documentURLString: documentURLString)
    }
    
    func deleteSubject(subjectID: UUID) async -> Result<Void, DatabaseError> {
        await actor.deleteSubject(subjectID: subjectID)
    }
    
    func getSubject(subjectID: UUID) async -> Result<SubjectEntity?, DatabaseError> {
        await actor.getSubjectFromSubjectID(subjectID: subjectID)
    }
    
    func deleteDocumentFromSubject(subjectID: UUID, documentURLString: String) async -> Result<Void, DatabaseError> {
        await actor.deleteDocumentFromSubject(subjectID: subjectID, documentURLString: documentURLString)
    }
    
    func storeQuiz(quiz: QuizEntity) async -> Result<Void, DatabaseError> {
        await actor.storeQuiz(quiz: quiz)
    }
    
    func getQuizes(subjectID: UUID) async -> Result<[QuizEntity], DatabaseError> {
        await actor.getQuizes(subjectID: subjectID)
    }
    
    func deleteQuiz(quizID: UUID) async -> Result<Void, DatabaseError> {
        await actor.deleteQuiz(quizID: quizID)
    }
    
    func updateQuizOnCompletion(quizID: UUID, highScore: Int, selectedOptionsIDs: [UUID]) async -> Result<Void, DatabaseError> {
        await actor.updateQuizOnCompletion(quizID: quizID, highScore: highScore, selectedOptionsIDs: selectedOptionsIDs)
    }
    
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async -> Result<Void, DatabaseError> {
        await actor.updateSubject(subjectID: subjectID, score: score, scoreText: scoreText)
    }
}
