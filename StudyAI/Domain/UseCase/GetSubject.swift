//
//  GetSubject.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 25/3/25.
//

import Foundation

protocol GetSubjectType {
    func execute(subjectID: UUID) async -> Subject?
}

class GetSubject: GetSubjectType {
    private let getSubjectRepository: GetSubjectRepositoryType
    
    init(getSubjectRepository: GetSubjectRepositoryType) {
        self.getSubjectRepository = getSubjectRepository
    }
    
    func execute(subjectID: UUID) async -> Subject? {
        await self.getSubjectRepository.getSubject(subjectID: subjectID)
    }
}
