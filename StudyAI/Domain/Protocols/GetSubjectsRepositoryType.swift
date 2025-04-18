//
//  GetSubjectsRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 22/3/25.
//

protocol GetSubjectsRepositoryType {
    func getSubjectsFromDB() async -> Result<[Subject], SubjectDomainError>
}
