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
    
    func addSubject(subject: SubjectEntity) async {
        await actor.addSubject(subject: subject)
    }
    
    func addDocumentURLToSubject(subjectID: UUID, documentURLString: String) async {
        await actor.addDocumentToSubject(subjectID: subjectID, documentURLString: documentURLString)
    }
    
    func deleteSubject(subjectID: UUID) async {
        await actor.deleteSubject(subjectID: subjectID)
    }
    
    func getSubject(subjectID: UUID) async -> SubjectEntity? {
        await actor.getSubjectFromSubjectID(subjectID: subjectID)
    }
    
    func deleteDocumentFromSubject(subjectID: UUID, documentURLString: String) async {
        await actor.deleteDocumentFromSubject(subjectID: subjectID, documentURLString: documentURLString)
    }
    
    func storeQuiz(quiz: QuizEntity) async {
        await actor.storeQuiz(quiz: quiz)
    }
    
    func getQuizes(subjectID: UUID) async -> [QuizEntity]? {
        await actor.getQuizes(subjectID: subjectID)
    }
    
    func deleteQuiz(quizID: UUID) async {
        await actor.deleteQuiz(quizID: quizID)
    }
    
    func updateQuizOnCompletion(quizID: UUID, highScore: Int) async {
        await actor.updateQuizOnCompletion(quizID: quizID, highScore: highScore)
    }
    
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async {
        await actor.updateSubject(subjectID: subjectID, score: score, scoreText: scoreText)
    }
}
