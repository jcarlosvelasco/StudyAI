//
//  DeleteDocumentFromSubject.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 25/3/25.
//

import Foundation

protocol DeleteDocumentFromSubjectType {
    func execute(subjectID: UUID, filePath: URL) async -> Result<Void, SubjectDomainError>
}

class DeleteDocumentFromSubject: DeleteDocumentFromSubjectType {
    private let deleteDocumentFromSubjectRepo: DeleteDocumentFromSubjectRepositoryType
    
    init(deleteDocumentFromSubjectRepo: DeleteDocumentFromSubjectRepositoryType) {
        self.deleteDocumentFromSubjectRepo = deleteDocumentFromSubjectRepo
    }
    
    func execute(subjectID: UUID, filePath: URL) async -> Result<Void, SubjectDomainError> {
        await self.deleteDocumentFromSubjectRepo.deleteDocumentFromSubject(subjectID: subjectID, filePath: filePath)
    }
}
