//
//  AddDocumentsToSubjectRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import Foundation

protocol AddDocumentsToSubjectRepositoryType {
    func addDocumentsToSubject(subjectID: UUID, fileURLs: [URL]) async -> Result<Void, SubjectDomainError>
}
