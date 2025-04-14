//
//  GetSubjectRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 25/3/25.
//

import Foundation

protocol GetSubjectRepositoryType {
    func getSubject(subjectID: UUID) async -> Subject?
}
