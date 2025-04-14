//
//  DeleteSubjectRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import Foundation

protocol DeleteSubjectRepositoryType {
    func deleteSubject(subjectID: UUID) async
}
