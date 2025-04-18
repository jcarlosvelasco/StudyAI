//
//  GetSubjects.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//


protocol GetSubjectsType {
    func execute() async -> Result<[Subject], SubjectDomainError>
}

class GetSubjects: GetSubjectsType {
    private var getSubjectsRepo: GetSubjectsRepositoryType
    
    init(getSubjectsRepo: GetSubjectsRepositoryType) {
        Logger.log(.info, "Init")
        self.getSubjectsRepo = getSubjectsRepo
    }
    
    func execute() async -> Result<[Subject], SubjectDomainError> {
        return await getSubjectsRepo.getSubjectsFromDB()
    }
}
