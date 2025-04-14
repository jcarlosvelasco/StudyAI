//
//  SubjectRepository.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 22/3/25.
//

import Foundation

class SubjectRepository:
    GetSubjectsRepositoryType,
    AddSubjectRepositoryType,
    AddDocumentsToSubjectRepositoryType,
    DeleteSubjectRepositoryType,
    GetSubjectRepositoryType,
    DeleteDocumentFromSubjectRepositoryType,
    UpdateSubjectRepositoryType,
    GetAIScoreRepositoryType
{
    private let database: DatabaseInfrastructureType
    private let subjectEntityMapper: SubjectEntityMapper
    private let subjectMapper: SubjectMapper
    private let llm: LLMInfrastructureType
    
    init(
        database: DatabaseInfrastructureType,
        subjectEntityMapper: SubjectEntityMapper,
        subjectMapper: SubjectMapper,
        llm: LLMInfrastructureType
    ) {
        print("Subject Repository, Init")
        self.database = database
        self.subjectEntityMapper = subjectEntityMapper
        self.subjectMapper = subjectMapper
        self.llm = llm
    }
    
    func getSubjectsFromDB() async -> [Subject] {
        let result = await database.getSubjects()
        return result.map { subjectEntityMapper.mapToSubject(entity: $0) }    
    }
    
    func addSubject(name: String) async {
        let subject = Subject(name: name)
        let subjectEntity = subjectMapper.mapToSubjectEntity(subject: subject)
        await database.addSubject(subject: subjectEntity)
    }
    
    func addDocumentsToSubject(subjectID: UUID, fileURLs: [URL]) async {
        for fileURL in fileURLs {
            await database.addDocumentURLToSubject(subjectID: subjectID, documentURLString: fileURL.absoluteString)
        }
    }
    
    func deleteSubject(subjectID: UUID) async {
        await database.deleteSubject(subjectID: subjectID)
    }
    
    func getSubject(subjectID: UUID) async -> Subject? {
        let entity = await database.getSubject(subjectID: subjectID)
        if let entity = entity {
            return subjectEntityMapper.mapToSubject(entity: entity)
        }
        return nil
    }
    
    func deleteDocumentFromSubject(subjectID: UUID, filePath: URL) async {
        await database.deleteDocumentFromSubject(subjectID: subjectID, documentURLString: filePath.absoluteString)
    }
    
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async {
        await database.updateSubject(subjectID: subjectID, score: score, scoreText: scoreText)
    }
    
    func getAIScore(text: String) async -> String? {
        let response = await llm.sendText(text: text)
        return response?.choices.first?.message.content
    }
}
