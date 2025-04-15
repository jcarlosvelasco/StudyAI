//
//  QuizView.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import SwiftUI
import Factory

struct QuizView: View {
    @StateObject var viewModel: QuizViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ], colors: [
                    .cyan, .blue, .cyan,
                    .blue, .cyan, .blue,
                    .cyan, .blue, .cyan
                ])
                .ignoresSafeArea()
            
            VStack {
                if (viewModel.quiz == nil) {
                    Text("Error")
                }
                else {
                    if viewModel.showScore {
                        VStack {
                            Spacer()
                            Text("Your score is: ")
                            Text(viewModel.score.description)
                                .bold()
                                .font(.largeTitle)
                                .padding()
                                .transition(.scale)
                            
                            if viewModel.showNewHighScoreText {
                                Text("New high score!")
                            }
                            
                            Spacer()
                            Spacer()
                            Button(
                                action: {
                                    presentationMode.wrappedValue.dismiss()
                                },
                                label: {
                                    Spacer()
                                    Text("Back").bold().foregroundStyle(Color.black)
                                    Spacer()
                                }
                            )
                            .padding()
                            .padding(.horizontal)
                            .background((Color.white).clipShape(RoundedRectangle(cornerRadius: 8)))
                        }
                        .padding()
                        .foregroundStyle(Color.white)
                    }
                    else {
                        HStack {
                            ForEach(viewModel.quiz!.questions.indices, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 4.0)
                                    .fill(index == viewModel.index ? Color.white : Color.white.opacity(0.3))
                                    .frame(height: 8)
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        HStack {
                            Text(viewModel.quiz!.questions[viewModel.index].question).bold()
                                .padding()
                            Spacer()
                        }
                        .background((Color.white).clipShape(RoundedRectangle(cornerRadius: 8)))
                        .padding()
                        
                        Spacer()
                        VStack {
                            HStack {
                                Text("Choose your answer").bold()
                                Spacer()
                            }.foregroundStyle(.white)
                            
                            ForEach(viewModel.quiz!.questions[viewModel.index].options, id: \.id) { option in
                                QuizOption(
                                    option: option,
                                    onItemClick: viewModel.onItemClick,
                                    selectedOptionID: viewModel.selectedOptionID,
                                    showResult: viewModel.showResult,
                                    correctOptionID: viewModel.quiz?.questions[viewModel.index].correctOptionID
                                )
                            }
                            
                            HStack {
                                Button(action: {
                                    viewModel.showingAlert.toggle()
                                }, label: {
                                    Text("Exit")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                })
                                .alert("Are you sure you wanna exit the quiz?", isPresented: $viewModel.showingAlert) {
                                    Button("Cancel") {
                                        viewModel.showingAlert.toggle()
                                    }
                                    Button("OK", role: .cancel) {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        viewModel.onNextClick()
                                    }
                                }) {
                                    Text("Next")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .disabled(viewModel.selectedOptionID == nil || viewModel.showResult == true)
                            }
                            .padding(.top)
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let scene = UIApplication.shared.connectedScenes.first,
               let sceneDelegate = scene as? UIWindowScene,
               sceneDelegate.interfaceOrientation.isPortrait {
                viewModel.orientation = .portrait
            } else {
                viewModel.orientation = .landscapeLeft
            }
        }
    }
}

#Preview {
    QuizView(viewModel: QuizViewModel(
        quiz: Helpers.createSampleQuiz())
    )
}
