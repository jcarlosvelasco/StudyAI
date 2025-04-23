//
//  QuizViewModel.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation
import Factory

class QuizViewModel: ObservableObject {
    let quiz: Quiz?
    
    @Published var index = 0
    private var selectedOptionsIDs: [UUID] = []

    @Published var showResult: Bool = false
    @Published var showScore: Bool = false
    @Published var showingAlert: Bool = false
    @Published var showNewHighScoreText: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var selectedOptionID: UUID?
    
    private let updateQuiz: UpdateQuizOnCompletionType
    private let quizPresentableErrorMapper: QuizPresentableErrorMapper
    
    var score = 0
    var errorMessage: String = ""
        
    init(
        quiz: Quiz?,
        updateQuiz: UpdateQuizOnCompletionType = Container.shared.updateQuizOnCompletion(),
        quizPresentableErrorMapper: QuizPresentableErrorMapper = Container.shared.quizPresentableErrorMapper()
    ) {
        Logger.log(.info, "Init")
        self.quiz = quiz
        self.updateQuiz = updateQuiz
        self.quizPresentableErrorMapper = quizPresentableErrorMapper
    }
    
    func onNextClick() {
        guard let quiz = quiz else { return }
        
        selectedOptionsIDs.append(selectedOptionID!)

        if selectedOptionID == quiz.questions[index].correctOptionID {
            score += 1
        }
        
        DispatchQueue.main.async {
            self.showResult.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.selectedOptionID = nil
            self.showResult.toggle()
            
            if self.index < quiz.questions.count - 1 {
                self.index += 1
            }
            else {
                self.showScore.toggle()
                Task {
                    await self.onUpdateQuiz()
                }
            }
        }
    }
    
    func onUpdateQuiz() async {
        guard let quiz = quiz else { return }
        Logger.log(.info, "Selected options: \(selectedOptionsIDs)")
        
        if self.score > quiz.highestScore {
            DispatchQueue.main.async {
                self.showNewHighScoreText.toggle()
            }
            
            let result = await updateQuiz.execute(quizID: quiz.id, highScore: self.score, selectedOptionsIDs: selectedOptionsIDs)
            guard case .success() = result else {
                if case .failure(let error) = result {
                    handleQuizError(error: error)
                } else {
                    handleQuizError(error: nil)
                }
                return
            }
        }
    }
    
    func onItemClick(optionID: UUID) {
        DispatchQueue.main.async {
            self.selectedOptionID = optionID
        }
    }
}

extension QuizViewModel {
    private func handleQuizError(error: QuizDomainError?) {
        errorMessage = quizPresentableErrorMapper.map(error: error)
        DispatchQueue.main.async {
            self.showErrorAlert.toggle()
        }
    }
}
