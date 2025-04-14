//
//  SubjectDetailViewModel.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import Foundation
import Factory

class SubjectDetailViewModel: ObservableObject {
    let subject: Subject
    let allowedMultipleFiles = Config.allowMultipleFiles
    let allowedFileExtensions = Config.allowedFileExtensions
    
    @Published var filePaths: [URL] = []
    @Published var isImporting = false
    @Published var showCreateQuizSheet: Bool = false
    @Published var newQuizName: String = ""
    @Published var selectedFiles: [URL] = []
    @Published var shouldNavigateToQuiz = false
    @Published var quizes: [Quiz] = []
    @Published var isLoading: Bool = false
    @Published var score: Int = 0
    @Published var scoreText: String?
    
    private let addDocumentsToSubject: AddDocumentsToSubjectType
    private let getSubject: GetSubjectType
    private let deleteDocumentFromSubject: DeleteDocumentFromSubjectType
    private let readPdf: ReadPDFType
    private let createQuiz: CreateQuizType
    private let getQuizes: GetQuizesType
    private let storeQuiz: StoreQuizType
    private let deleteQuiz: DeleteQuizType
    private let updateSubject: UpdateSubjectType
    private let getAIScore: GetAIScoreTextType
    
    var quiz: Quiz?
    
    init(
        subject: Subject,
        addDocumentsToSubject: AddDocumentsToSubjectType = Container.shared.addDocumentsToSubject(),
        getSubject: GetSubjectType = Container.shared.getSubject(),
        deleteDocumentFromSubject: DeleteDocumentFromSubjectType = Container.shared.deleteDocumentFromSubject(),
        readPDF: ReadPDFType = Container.shared.readPDF(),
        createQuiz: CreateQuizType = Container.shared.createQuiz(),
        getQuizes: GetQuizesType = Container.shared.getQuizes(),
        storeQuiz: StoreQuizType = Container.shared.storeQuiz(),
        deleteQuiz: DeleteQuizType = Container.shared.deleteQuiz(),
        updateSubject: UpdateSubjectType = Container.shared.updateSubject(),
        getAIScore: GetAIScoreTextType = Container.shared.getAIScoreText()
    ) {
        print("SubjectDetailViewModel, init")
        self.subject = subject
        self.addDocumentsToSubject = addDocumentsToSubject
        self.getSubject = getSubject
        self.deleteDocumentFromSubject = deleteDocumentFromSubject
        self.readPdf = readPDF
        self.createQuiz = createQuiz
        self.getQuizes = getQuizes
        self.storeQuiz = storeQuiz
        self.deleteQuiz = deleteQuiz
        self.updateSubject = updateSubject
        self.getAIScore = getAIScore
        
        Task {
            await getDocuments(subjectID: subject.id)
        }
    }
    
    deinit {
        print("SubjectDetailViewModel, deinit")
    }
    
    func fetchQuizes() async {
        print("SubjectDetailViewModel, Fetch Quizzes")

        let fetchedQuizes = await getQuizes.execute(subjectID: subject.id)
        DispatchQueue.main.async {
            self.quizes = fetchedQuizes
        }
        
        if fetchedQuizes.isEmpty {
            return
        }

        let updatedSubject = await getSubject.execute(subjectID: subject.id)
        guard let updatedSubject else {
            return
        }

        print("SubjectDetailViewModel, Fetch Quizzes, updated subject: \(updatedSubject.lastAIScoreUpdate?.description ?? "nil")")
        
        DispatchQueue.main.async {
            self.score = updatedSubject.score
            self.scoreText = updatedSubject.scoreText
        }
                
        if updatedSubject.lastAIScoreUpdate == nil {
            print("SubjectDetailViewModel, Last AI Score update is nil, calculating score...")
            self.score = 0
        }
        else {
            var biggestDate: Date = Date.distantPast
            for quiz in fetchedQuizes {
                if let date = quiz.lastTimeCompleted {                    
                    if date.timeIntervalSince1970 > biggestDate.timeIntervalSince1970 {
                        biggestDate = date
                    }
                }
                else {
                    print("Nil date")
                }
            }
            print("Quiz last done date: \(biggestDate.description)")
            print("FetchQuizzes date: \(updatedSubject.lastAIScoreUpdate!.description)")
            if Int(updatedSubject.lastAIScoreUpdate!.timeIntervalSince1970) < Int(biggestDate.timeIntervalSince1970) {
                print("Subject last ai score update bigger than biggest date, calculating score...")
                await calculateScore(quizzes: fetchedQuizes)
            }
        }
    }
    
    func getDocuments(subjectID: UUID) async {
        let result = await getSubject.execute(subjectID: subjectID)
        if let result = result {
            DispatchQueue.main.async {
                self.filePaths = result.fileURLs.map { $0 }
            }
        }
    }
    
    func addDocuments(fileURLs: [URL]) async {
        let filteredFiles = fileURLs.filter { !self.filePaths.contains($0) }
        await addDocumentsToSubject.execute(subjectID: subject.id, fileURLs: filteredFiles)
        
        for fileURL in filteredFiles {
            DispatchQueue.main.async {
                self.filePaths.append(fileURL)
            }
        }
    }
    
    func onDelete(filePath: URL) async {
        await self.deleteDocumentFromSubject.execute(subjectID: subject.id, filePath: filePath)
        DispatchQueue.main.async {
            self.filePaths = self.filePaths.filter { $0 != filePath }
        }
    }
    
    func onDocumentSelect(path: URL) {
        if self.selectedFiles.contains(path) {
            DispatchQueue.main.async {
                self.selectedFiles.removeAll { $0 == path }
            }
        }
        else {
            DispatchQueue.main.async {
                self.selectedFiles.append(path)
            }
        }
    }
    
    func onCreateQuiz() async {
        DispatchQueue.main.async {
            self.isLoading.toggle()
        }
        if let createdQuiz = await createQuiz.execute(documentURLs: self.selectedFiles, name: newQuizName, subjectID: subject.id) {
            self.quiz = createdQuiz
            await storeQuiz.execute(quiz: createdQuiz)
            
            DispatchQueue.main.async {
                self.isLoading.toggle()
                self.shouldNavigateToQuiz = true
            }
        } else {
            DispatchQueue.main.async {
                self.isLoading.toggle()
            }
            print("Error: No se pudo crear el quiz")
        }
    }
    
    func onDeleteQuiz(quizID: UUID) async {
        await deleteQuiz.execute(quizID: quizID)
        let newQuizes = self.quizes.filter { $0.id != quizID }
        DispatchQueue.main.async {
            self.quizes = newQuizes
        }
        
        await calculateScore(quizzes: newQuizes)
    }
    
    func calculateScore(quizzes: [Quiz]) async {
        print("Calculate score")
        
        DispatchQueue.main.async {
            self.score = 0
            self.scoreText = nil
        }
                
        var totalQuestions = 0
        for quiz in quizzes {
            print("Quiz")
            for _ in quiz.questions {
                totalQuestions += 1
            }
        }
        print("Total questions: \(totalQuestions)")
        guard totalQuestions > 0 else {
            return
        }

        let totalScore = quizzes.reduce(0) { $0 + $1.highestScore }
        let result = (totalScore * 100) / totalQuestions
        print("Result: \(result)")
        let text = await getAIScore.execute(score: result, quizzes: quizes)
        
        DispatchQueue.main.async {
            self.score = result
            self.scoreText = text
        }
        
        Task {
            await updateSubject.execute(subjectID: subject.id, score: result, scoreText: text)
        }
    }
}
