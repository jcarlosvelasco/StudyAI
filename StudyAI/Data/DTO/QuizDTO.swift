//
//  QuizDTO.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

struct QuizResponse: Codable {
    let quiz: QuizDTO
}

struct QuizDTO: Codable {
    let questions: [QuestionDTO]
}

struct QuestionDTO: Codable {
    let id: Int
    let question: String
    let options: [String]
    let correctAnswer: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case question
        case options
        case correctAnswer = "correct_answer"
    }
}
