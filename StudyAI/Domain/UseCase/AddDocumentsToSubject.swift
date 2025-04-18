//
//  AddDocumentsToSubject.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import Foundation

protocol AddDocumentsToSubjectType {
    func execute(subjectID: UUID, fileURLs: [URL]) async -> Result<Void, SubjectDomainError>
}

class AddDocumentsToSubject: AddDocumentsToSubjectType {
    private let addDocumentsToSubjectRepository: AddDocumentsToSubjectRepositoryType
    
    init(addDocumentsToSubjectRepository: AddDocumentsToSubjectRepositoryType) {
        self.addDocumentsToSubjectRepository = addDocumentsToSubjectRepository
    }
    
    func execute(subjectID: UUID, fileURLs: [URL]) async -> Result<Void, SubjectDomainError> {
        return await addDocumentsToSubjectRepository.addDocumentsToSubject(subjectID: subjectID, fileURLs: fileURLs)
    }
}
