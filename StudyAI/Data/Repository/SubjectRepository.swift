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
    
    func getSubjectsFromDB() async -> Result<[Subject], SubjectDomainError> {
        let result = await database.getSubjects()
        
        guard case .success(let subjectEntities) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
                
        let subjects = subjectEntities.map { subjectEntityMapper.mapToSubject(entity: $0) }
        return .success(subjects)
    }
    
    func addSubject(name: String) async -> Result<Void, SubjectDomainError> {
        let subject = Subject(name: name)
        let subjectEntity = subjectMapper.mapToSubjectEntity(subject: subject)
        let result = await database.addSubject(subject: subjectEntity)
        
        guard case .success() = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        
        return .success(())
    }
    
    func addDocumentsToSubject(subjectID: UUID, fileURLs: [URL]) async -> Result<Void, SubjectDomainError> {
        for fileURL in fileURLs {
            let result = await database.addDocumentURLToSubject(subjectID: subjectID, documentURLString: fileURL.absoluteString)
            guard case .success() = result else {
                guard case .failure(let error) = result else {
                    return .failure(.generic)
                }
                return .failure(errorMapper.map(error: error))
            }
        }
        
        return .success(())
    }
    
    func deleteSubject(subjectID: UUID) async -> Result<Void, SubjectDomainError> {
        let result = await database.deleteSubject(subjectID: subjectID)
        guard case .success() = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        
        return .success(())
    }
    
    func getSubject(subjectID: UUID) async -> Result<Subject?, SubjectDomainError> {
        let result = await database.getSubject(subjectID: subjectID)
        guard case .success(let entity) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        
        if let entity = entity {
            let subject = subjectEntityMapper.mapToSubject(entity: entity)
            return .success(subject)
        }
        return .success(nil)
    }
    
    func deleteDocumentFromSubject(subjectID: UUID, filePath: URL) async -> Result<Void, SubjectDomainError> {
        let result = await database.deleteDocumentFromSubject(subjectID: subjectID, documentURLString: filePath.absoluteString)
        guard case .success() = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        
        return .success(())
    }
    
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async -> Result<Void, SubjectDomainError> {
        let result = await database.updateSubject(subjectID: subjectID, score: score, scoreText: scoreText)
        guard case .success() = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        
        return .success(())
    }
    
    func getAIScore(text: String) async -> Result<String, SubjectDomainError> {
        Logger.log(.info, "Get AI Score")
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
