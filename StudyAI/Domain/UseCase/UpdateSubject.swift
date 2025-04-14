//
//  UpdateSubject.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 12/4/25.
//

import Foundation

protocol UpdateSubjectType {
    func execute(subjectID: UUID, score: Int, scoreText: String?) async
}


class UpdateSubject: UpdateSubjectType {
    private let updateSubjectRepositoryType: UpdateSubjectRepositoryType
    
    init(updateSubjectRepositoryType: UpdateSubjectRepositoryType) {
        self.updateSubjectRepositoryType = updateSubjectRepositoryType
    }
    
    func execute(subjectID: UUID, score: Int, scoreText: String?) async {
        await updateSubjectRepositoryType.updateSubject(subjectID: subjectID, score: score, scoreText: scoreText)
    }
}
