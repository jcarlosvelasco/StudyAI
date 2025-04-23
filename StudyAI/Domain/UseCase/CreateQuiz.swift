//
//  CreateQuiz.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

protocol CreateQuizType {
    func execute(documentURLs: [URL], name: String, subjectID: UUID) async -> Result<Quiz, QuizDomainError>
}

class CreateQuiz: CreateQuizType {
    private let createQuizRepository: CreateQuizRepositoryType
    private let readPDF: ReadPDFType
    private let locale: String
    
    private let initialPrompt: String

    init(
        createQuizRepository: CreateQuizRepositoryType,
        readPDF: ReadPDFType
    ) {
        self.createQuizRepository = createQuizRepository
        self.readPDF = readPDF
        
        if #available(iOS 16.0, *) {
            locale = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            locale = Locale.current.languageCode ?? "en"
        }
        
        self.initialPrompt = PromptConfig.quizPrompt(locale: locale)
    }
    
    func execute(documentURLs: [URL], name: String, subjectID: UUID) async -> Result<Quiz, QuizDomainError> {
        var readErrors: [DocumentDomainError] = []

        let contents = await withTaskGroup(of: Result<String, DocumentDomainError>.self) { group -> [String] in
            for documentURL in documentURLs {
                group.addTask {
                    await self.readPDF.execute(documentURL: documentURL)
                }
            }

            var results: [String] = []

            for await result in group {
                switch result {
                case .success(let content):
                    results.append(content)
                case .failure(let error):
                    readErrors.append(error)
                }
            }

            return results
        }

        if let _ = readErrors.first {
            return .failure(.generic)
        }

        let totalContent = initialPrompt + contents.joined()
        let result = await createQuizRepository.createQuiz(text: totalContent, name: name, subjectID: subjectID)
        return result
    }

}
