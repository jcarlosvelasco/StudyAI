//
//  UpdateSubjectRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 12/4/25.
//

import Foundation

protocol UpdateSubjectRepositoryType {
    func updateSubject(subjectID: UUID, score: Int, scoreText: String?) async
}
