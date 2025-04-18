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
    @Published var showErrorAlert: Bool = false
    
    var errorMessage: String = ""
            
    private let getSubjects: GetSubjectsType
    private let addSubject: AddSubjectType
    private let deleteSubject: DeleteSubjectType
    
    private let subjectPresentableErrorMapper: SubjectPresentableErrorMapper

    init(
        getSubjects: GetSubjectsType = Container.shared.getSubjects(),
        addSubject: AddSubjectType = Container.shared.getAddSubject(),
        deleteSubject: DeleteSubjectType = Container.shared.deleteSubject(),
        subjectPresentableErrorMapper: SubjectPresentableErrorMapper = Container.shared.subjectPresentableErrorMapper()
    ) {
        Logger.log(.info, "Init")
        self.getSubjects = getSubjects
        self.addSubject = addSubject
        self.deleteSubject = deleteSubject
        self.subjectPresentableErrorMapper = subjectPresentableErrorMapper
            
        Task {
            await fetchSubjects()
        }
    }
    
    func fetchSubjects() async {
        let result = await getSubjects.execute()
        guard case .success(let fetchedSubjects) = result else {
            if case .failure(let error) = result {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.subjects = fetchedSubjects
        }
    }
    
    func addSample() async {
        let result = await addSubject.execute(name: newSubjectName)
        guard case .success() = result else {
            if case .failure(let error) = result {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.newSubjectName = ""
        }
        await fetchSubjects()
    }
    
    func onDelete(subjectID: UUID) async {
        let result = await deleteSubject.execute(subjectID: subjectID)
        guard case .success() = result else {
            if case .failure(let error) = result {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            return
        }
        DispatchQueue.main.async {
            self.subjects = self.subjects.filter { $0.id != subjectID }
        }
    }
    
    private func handleSubjectError(error: SubjectDomainError?) {
        errorMessage = subjectPresentableErrorMapper.map(error: error)
        DispatchQueue.main.async {
            self.showErrorAlert.toggle()
        }
    }
}
