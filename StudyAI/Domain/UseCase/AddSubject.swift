//
//  AddSubject.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//

import SwiftData

protocol AddSubjectType {
    func execute(name: String) async -> Result<Void, SubjectDomainError>
}

class AddSubject: AddSubjectType {
    private let addSubjectRepository: AddSubjectRepositoryType
    
    init(addSubjectRepository: AddSubjectRepositoryType) {
        self.addSubjectRepository = addSubjectRepository
    }
    
    func execute(name: String) async -> Result<Void, SubjectDomainError> {
        await addSubjectRepository.addSubject(name: name)
    }
}
