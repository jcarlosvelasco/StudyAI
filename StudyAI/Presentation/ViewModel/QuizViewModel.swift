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
    @Published var selectedOptionID: UUID?
    @Published var showResult: Bool = false
    @Published var showScore: Bool = false
    @Published var showingAlert: Bool = false
    @Published var showNewHighScoreText: Bool = false
    
    private let updateQuiz: UpdateQuizOnCompletionType
    
    var score = 0
        
    init(
        quiz: Quiz?,
        updateQuiz: UpdateQuizOnCompletionType = Container.shared.updateQuizOnCompletion()
    ) {
        print("QuizViewModel, Init")
        self.quiz = quiz
        self.updateQuiz = updateQuiz
    }
    
    func onNextClick() {
        guard let quiz = quiz else { return }
        
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
        
        if self.score > quiz.highestScore {
            DispatchQueue.main.async {
                self.showNewHighScoreText.toggle()
            }
            
            await updateQuiz.execute(quizID: quiz.id, highScore: self.score)
        }
    }
    
    func onItemClick(optionID: UUID) {
        DispatchQueue.main.async {
            self.selectedOptionID = optionID
        }
    }
}
