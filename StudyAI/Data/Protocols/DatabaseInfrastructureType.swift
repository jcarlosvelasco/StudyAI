//
//  DatabaseInfrastructureType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 22/3/25.
//

import Foundation

enum DatabaseError: Error {
    case generic
}

protocol DatabaseInfrastructureType {
    func getSubjects() async -> Result<[SubjectEntity], DatabaseError>
    func addSubject(subject: SubjectEntity) async -> Result<Void, DatabaseError>
    func addDocumentURLToSubject(subjectID: UUID, documentURLString: String) async -> Result<Void, DatabaseError>
    func deleteSubject(subjectID: UUID) async -> Result<Void, DatabaseError>
    func getSubject(subjectID: UUID) async -> Result<SubjectEntity?, DatabaseError>
    func deleteDocumentFromSubject(subjectID: UUID, documentURLString: String) async -> Result<Void, DatabaseError>
    func storeQuiz(quiz: QuizEntity) async -> Result<Void, DatabaseError>
    func getQuizes(subjectID: UUID) async -> Result<[QuizEntity], DatabaseError>
    func deleteQuiz(quizID: UUID) async -> Result<Void, DatabaseError>
    func updateQuizOnCompletion(quizID: UUID, highScore: Int, selectedOptionsIDs: [UUID]) async -> Result<Void, DatabaseError>
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async -> Result<Void, DatabaseError>
}
