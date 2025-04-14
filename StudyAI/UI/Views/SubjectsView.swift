//
//  SubjectsView.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//

import SwiftUI

struct SubjectsView: View {
    @StateObject var subjectsVM: SubjectsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if (subjectsVM.subjects.isEmpty) {
                    Text("No subjects found")
                }
                else {
                    List {
                        ForEach(subjectsVM.subjects, id: \.id) { subject in
                            NavigationLink {
                                SubjectDetailView(
                                    viewModel: SubjectDetailViewModel(
                                        subject: subject
                                    )
                                )
                            } label: {
                                SubjectRowItem(
                                    subjectName: subject.name,
                                    onDelete: {
                                        Task {
                                            await subjectsVM.onDelete(subjectID: subject.id)
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        subjectsVM.showCategorySelector.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .navigationTitle("Subjects")
        }
        .sheet(isPresented: $subjectsVM.showCategorySelector) {
            VStack {
                HStack {
                    Text("Enter subject name").bold()
                    Spacer()
                }
                TextField("Subject name", text: $subjectsVM.newSubjectName)
                    .padding(.bottom)
                HStack {
                    Button(action: {
                        subjectsVM.showCategorySelector.toggle()
                    }, label: {
                        Text("Cancel")
                    })
                    Spacer()
                    Button(action: {
                        subjectsVM.showCategorySelector.toggle()
                        Task {
                            await subjectsVM.addSample()
                        }
                    }, label: {
                        Text("Accept")
                    })
                    .disabled(subjectsVM.newSubjectName.isEmpty)
                }
            }
            .padding()
            .adjustSheetHeightToContent()
        }
    }
}

struct SubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsView(
            subjectsVM: SubjectsViewModel()
        )
    }
}
