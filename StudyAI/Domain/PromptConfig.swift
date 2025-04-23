//
//  P.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/4/25.
//

struct PromptConfig {
    static func quizPrompt(locale: String) -> String {
        return #"""
        You need to create a quiz with the following PDF content. Both the questions and answers must be in the language: \#(locale). If you don't support that language, all the questions and answers must be in English. Each quiz will have four questions, with only one correct answer. The maximum amount of questions will be 12. Make sure your response is only a JSON with this format: {
            "quiz": {
              "questions": [
                {
                  "id": 1,
                  "question": "¿What is the capital of France?",
                  "options": ["Madrid", "Paris", "Roma", "Berlin"],
                  "correct_answer": "Paris"
                }
              ]
            }
          }
        """#
    }
    
    static func aiScorePrompt(locale: String, quizzesText: String, score: Int) -> String {
        return #"""
        Example 1:
        Quizzes:
        Quiz 1:
        What is 2 + 2?
        Options: {id: 1, option: 3} {id: 2, option: 4} {id: 3, option: 5}
        Correct option id: 2
        Selected option id: 2
        Quiz 2:
        What is the capital of Italy?
        Options: {id: 1, option: Madrid} {id: 2, option: Rome} {id: 3, option: Paris}
        Correct option id: 2
        Selected option id: 1
        Quiz 3:
        What is the capital of Spain?
        Options: {id: 1, option: Madrid} {id: 2, option: Rome} {id: 3, option: Paris}
        Correct option id: 1
        Selected option id: 3
        Score: 33
        Feedback: You need to keep working! Revisit a couple of tricky spots, like capital cities, to perfect your score.

        Example 2:
        Quizzes:
        Quiz 1:
        What is the derivative of x²?
        Options: {id: 1, option: x} {id: 2, option: 2x} {id: 3, option: x²}
        Correct option id: 2
        Selected option id: 2
        Quiz 2:
        Who wrote 'Hamlet'?
        Options: {id: 1, option: Shakespeare} {id: 2, option: Dickens} {id: 3, option: Tolkien}
        Correct option id: 1
        Selected option id: 2
        Score: 50
        Feedback: You're getting there! Focus more on literary authors and their most important works to boost your score.

        Now it's your turn.

        Quizzes:\#(quizzesText)
        Score: \#(score)
        Language: \#(locale)

        Based on the questions and on my score, give me a short feedback (2 sentences max) that summarizes my performance and helps me improve by focusing on the parts I need to review. Your answer must be in the language: \#(locale). If that language is not supported, respond in English. Only return the feedback text.
        """#
    }
}
