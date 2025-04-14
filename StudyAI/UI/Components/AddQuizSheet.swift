//
//  AddQuizSheet.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 27/3/25.
//

import SwiftUI

struct AddQuizSheet: View {
    @ObservedObject private var viewModel: SubjectDetailViewModel
    
    init(viewModel: SubjectDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Enter quiz name").bold()
                Spacer()
            }
            TextField("Quiz name", text: $viewModel.newQuizName)
            
            HStack {
                Text("Select files to include").bold()
                Spacer()
            }.padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(viewModel.filePaths, id: \.self) { path in
                        DocumentItem(
                            documentName: path.lastPathComponent,
                            onSelect: {
                                viewModel.onDocumentSelect(path: path)
                            },
                            isSelected: viewModel.selectedFiles.contains(path)
                        )
                    }
                }
            }
            
            HStack {
                Button(action: {
                    viewModel.showCreateQuizSheet.toggle()
                }, label: {
                    Text("Cancel")
                })
                Spacer()
                Button(action: {
                    viewModel.showCreateQuizSheet.toggle()
                    Task {
                        await viewModel.onCreateQuiz()
                    }
                }, label: {
                    Text("Create")
                })
                
                .disabled(viewModel.newQuizName.isEmpty || viewModel.selectedFiles.isEmpty)
                .padding()
            }
        }
        .padding()
        .adjustSheetHeightToContent()
    }
}
