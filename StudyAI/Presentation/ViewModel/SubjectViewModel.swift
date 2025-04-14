//
//  SubjectViewModel.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//

import Foundation
import Combine
import Factory

class SubjectsViewModel: ObservableObject {
    @Published var showCategorySelector: Bool = false
    @Published var newSubjectName: String = ""
    @Published var subjects: [Subject] = []
            
    private let getSubjects: GetSubjectsType
    private let addSubject: AddSubjectType
    private let deleteSubject: DeleteSubjectType

    init(
        getSubjects: GetSubjectsType = Container.shared.getSubjects(),
        addSubject: AddSubjectType = Container.shared.getAddSubject(),
        deleteSubject: DeleteSubjectType = Container.shared.deleteSubject()
    ) {
        print("SubjectsViewModel, init")
        self.getSubjects = getSubjects
        self.addSubject = addSubject
        self.deleteSubject = deleteSubject
            
        Task {
            await fetchSubjects()
        }
    }
    
    func fetchSubjects() async {
        let fetchedSubjects = await getSubjects.execute()
        DispatchQueue.main.async {
            self.subjects = fetchedSubjects
        }
    }
    
    func addSample() async {
        await addSubject.execute(name: newSubjectName)
        DispatchQueue.main.async {
            self.newSubjectName = ""
        }
        await fetchSubjects()
    }
    
    func onDelete(subjectID: UUID) async {
        await deleteSubject.execute(subjectID: subjectID)
        DispatchQueue.main.async {
            self.subjects = self.subjects.filter { $0.id != subjectID }
        }
    }
}
