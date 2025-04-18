//
//  SubjectsView.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/3/25.
//

import SwiftUI

struct SubjectsView: View {
    @StateObject var viewModel: SubjectsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if (viewModel.subjects.isEmpty) {
                    Text("No subjects found")
                }
                else {
                    List {
                        ForEach(viewModel.subjects, id: \.id) { subject in
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
                                            await viewModel.onDelete(subjectID: subject.id)
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
                        viewModel.showCategorySelector.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .navigationTitle("Subjects")
        }
        .sheet(isPresented: $viewModel.showCategorySelector) {
            VStack {
                HStack {
                    Text("Enter subject name").bold()
                    Spacer()
                }
                TextField("Subject name", text: $viewModel.newSubjectName)
                    .padding(.bottom)
                HStack {
                    Button(action: {
                        viewModel.showCategorySelector.toggle()
                    }, label: {
                        Text("Cancel")
                    })
                    Spacer()
                    Button(action: {
                        viewModel.showCategorySelector.toggle()
                        Task {
                            await viewModel.addSample()
                        }
                    }, label: {
                        Text("Accept")
                    })
                    .disabled(viewModel.newSubjectName.isEmpty)
                }
            }
            .padding()
            .adjustSheetHeightToContent()
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = ""
                viewModel.showErrorAlert.toggle()
            }
        }
    }
}

struct SubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsView(
            viewModel: SubjectsViewModel()
        )
    }
}
