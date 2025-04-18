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
    func addSubject(subject: SubjectEntity) async
    func addDocumentURLToSubject(subjectID: UUID, documentURLString: String) async
    func deleteSubject(subjectID: UUID) async
    func getSubject(subjectID: UUID) async -> SubjectEntity?
    func deleteDocumentFromSubject(subjectID: UUID, documentURLString: String) async
    func storeQuiz(quiz: QuizEntity) async
    func getQuizes(subjectID: UUID) async -> [QuizEntity]?
    func deleteQuiz(quizID: UUID) async
    func updateQuizOnCompletion(quizID: UUID, highScore: Int) async
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async
}
