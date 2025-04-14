//
//  APIResponseMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

class APIResponseMapper {
    private let quizDTOMapper: QuizDTOMapper
    
    init(quizDTOMapper: QuizDTOMapper) {
        self.quizDTOMapper = quizDTOMapper
    }
    
    func mapAPIResponseToQuiz(response: APIResponse, name: String, subjectID: UUID) -> Quiz? {
        guard let answer = response.choices.first?.message.content else {
            print("No content found in the response.")
            return nil
        }
        
        let cleanedAnswer = answer
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(cleanedAnswer)
        let quizResponse: QuizResponse
                
        do {
            if let jsonData = cleanedAnswer.data(using: .utf8) {
                let decoder = JSONDecoder()
                quizResponse = try decoder.decode(QuizResponse.self, from: jsonData)
                
                let quizDTO = quizResponse.quiz
                let quiz = quizDTOMapper.mapQuizDTOToQuiz(dto: quizDTO, name: name, subjectID: subjectID)
                return quiz
            } else {
                print("Error al convertir el string a Data.")
                return nil
            }
        } catch {
            print("Error al decodificar el JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
