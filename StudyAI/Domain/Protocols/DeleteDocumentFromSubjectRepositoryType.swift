//
//  DeleteDocumentFromSubjectRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 25/3/25.
//

import Foundation

protocol DeleteDocumentFromSubjectRepositoryType {
    func deleteDocumentFromSubject(subjectID: UUID, filePath: URL) async -> Result<Void, SubjectDomainError>
}
