//
//  SubjectDetailView.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import SwiftUI

struct SubjectDetailView: View {
    @StateObject var viewModel: SubjectDetailViewModel
    
    var body: some View {
        if viewModel.isLoading {
            GenerateQuizView()
                .toolbar(.hidden, for: .tabBar)
        }
        else {
            VStack {
                if (viewModel.filePaths.isEmpty) {
                    Text("No files found")
                }
                else {
                    List {
                        if (!viewModel.quizes.isEmpty) {
                            Section {
                                AIScore(score: viewModel.score, text: viewModel.scoreText)
                                    .listRowInsets(EdgeInsets())
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color.blue.opacity(0.1))
                            }
                        }

                        if !viewModel.filePaths.isEmpty {
                            Section(header: Text("Archivos (\(viewModel.filePaths.count))")) {
                                ForEach(viewModel.filePaths, id: \.self) { filePath in
                                    Text(filePath.shortDisplayPath(keepLastComponents: 2))
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                Task {
                                                    await viewModel.onDelete(filePath: filePath)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }

                        if !viewModel.quizes.isEmpty {
                            Section(header: Text("Quizes (\(viewModel.quizes.count))")) {
                                ForEach(viewModel.quizes, id: \.id) { quiz in
                                    NavigationLink {
                                        QuizView(viewModel: QuizViewModel(quiz: quiz))
                                            .toolbar(.hidden, for: .tabBar)
                                    } label: {
                                        QuizItem(quiz: quiz, onDelete: {
                                            Task {
                                                await viewModel.onDeleteQuiz(quizID: quiz.id)
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle(viewModel.subject.name)
            .fileImporter(
                isPresented: $viewModel.isImporting,
                allowedContentTypes: viewModel.allowedFileExtensions,
                allowsMultipleSelection: viewModel.allowedMultipleFiles,
                onCompletion: { results in
                    switch results {
                    case .success(let fileurls):
                        Task {
                            await viewModel.addDocuments(fileURLs: fileurls)
                        }
                        
                    case .failure(let error):
                        Logger.log(.error, error.localizedDescription)
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Add new file") {
                            viewModel.isImporting.toggle()
                        }
                        .buttonStyle(BorderedButtonStyle())
                        
                        Spacer()
                        
                        Button("Create quiz") {
                            viewModel.showCreateQuizSheet.toggle()
                        }
                        .disabled(viewModel.filePaths.isEmpty)
                        .buttonStyle(BorderedButtonStyle())
                    }
                    .padding()
                    .padding(.bottom)
                }
            }
            .sheet(isPresented: $viewModel.showCreateQuizSheet) {
                AddQuizSheet(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigateToQuiz) {
                QuizView(viewModel: QuizViewModel(
                    quiz: viewModel.quiz)
                )
                .toolbar(.hidden, for: .tabBar)
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorAlert) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = ""
                    viewModel.showErrorAlert.toggle()
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchQuizzes()
                }
            }
        }
    }
}

#Preview {
    SubjectDetailView(
        viewModel: SubjectDetailViewModel(
            subject: Subject(name: "Patata")
        )
    )
}
