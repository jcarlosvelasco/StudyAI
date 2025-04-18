//
//  DeleteSubject.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import Foundation

protocol DeleteSubjectType {
    func execute(subjectID: UUID) async -> Result<Void, SubjectDomainError>
}

class DeleteSubject: DeleteSubjectType {
    private let deleteSubjectRepository: DeleteSubjectRepositoryType
    
    init(deleteSubjectRepository: DeleteSubjectRepositoryType) {
        self.deleteSubjectRepository = deleteSubjectRepository
    }
    
    func execute(subjectID: UUID) async -> Result<Void, SubjectDomainError> {
        await deleteSubjectRepository.deleteSubject(subjectID: subjectID)
    }
}
