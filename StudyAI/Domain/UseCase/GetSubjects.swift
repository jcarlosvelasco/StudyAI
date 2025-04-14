//
//  GetSubjects.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//


protocol GetSubjectsType {
    func execute() async -> [Subject]
}

class GetSubjects: GetSubjectsType {
    private var getSubjectsRepo: GetSubjectsRepositoryType
    
    init(getSubjectsRepo: GetSubjectsRepositoryType) {
        print("Get subjects init")
        self.getSubjectsRepo = getSubjectsRepo
    }
    
    func execute() async -> [Subject] {
        return await getSubjectsRepo.getSubjectsFromDB()
    }
}
