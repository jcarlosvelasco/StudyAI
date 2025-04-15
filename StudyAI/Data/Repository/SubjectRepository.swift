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
    
    private let mapper: APIResponseMapper
    private let apiDataSource: APIDataSourceType
    private let errorMapper: SubjectDomainErrorMapper
    
    init(
        database: DatabaseInfrastructureType,
        subjectEntityMapper: SubjectEntityMapper,
        subjectMapper: SubjectMapper,
        mapper: APIResponseMapper,
        apiDataSource: APIDataSourceType,
        errorMapper: SubjectDomainErrorMapper
    ) {
        Logger.log(.info, "Init")
        self.database = database
        self.subjectEntityMapper = subjectEntityMapper
        self.subjectMapper = subjectMapper
        self.mapper = mapper
        self.apiDataSource = apiDataSource
        self.errorMapper = errorMapper
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
    
    func getAIScore(text: String) async -> Result<String, SubjectDomainError> {
        let result = await apiDataSource.sendMessageToLLM(text: text)
        guard case .success(let response) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }

        let answer = mapper.mapToLLMAnswer(response: response)
        
        guard let answer = answer else {
            return .failure(.generic)
        }
        
        return .success(answer)
    }
}
