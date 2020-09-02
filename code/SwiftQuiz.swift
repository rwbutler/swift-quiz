//
//  SwiftQuiz.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation
import Hash

public class SwiftQuiz {
    
    public typealias PackageQuizResult = Result<Void, Error>
    public typealias QuizResult = Result<Quiz, Error>
    typealias QuestionKey = UUID
    
    private var answers: [QuestionKey: [String]] = [:]
    private var currentQuestion: Question?
    private var currentRound: Round?
    private let queue = OperationQueue()
    private var previousOperation: Operation?
    private let externalQueue: DispatchQueue = DispatchQueue.global(qos: .userInteractive)
    private let internalQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    private var player: String?
    private var quiz: Quiz?
    private var quizData: Data?
    private let quizURL: URL
    private var accessControlService: AccessControlService?
    
    public var advanceAutomatically: Bool = true
    public var eventCallback: ((QuizEvent) -> Void)?
    public var errorCallback: ((Error) -> Void)?
    
    // TODO: Provide a cleaner interface to this service.
    public var imagesService: ImagesService?
    
    public init(quizURL: URL) {
        self.quizURL = quizURL
    }
    
    public func nextQuestion() {
        switch (currentRound, currentQuestion) {
        case (.none, .none), (.none, .some(_)):
            if advanceAutomatically {
                startQuiz()
            }
        case (.some(let round), .none):
            guard let firstQuestion = round.questions.first else {
                invokeCallback(with: QuizError.emptyRound)
                return
            }
            currentQuestion = firstQuestion
            invokeCallback(with: .question(firstQuestion.question))
            if let image = firstQuestion.image {
                imagesService?.showImage(questionId: firstQuestion.id, image: image)
            }
        case (.some(let round), .some(let question)):
            guard let questionIndex = round.questions.firstIndex(where: { roundQuestion in
                roundQuestion == question
            }) else {
                return
            }
            let nextQuestionIndex = questionIndex.advanced(by: 1)
            guard nextQuestionIndex != round.questions.endIndex else {
                if advanceAutomatically {
                    nextRound()
                }
                return
            }
            guard let nextQuestion = currentRound?.questions[nextQuestionIndex] else {
                invokeCallback(with: QuizError.internalError)
                return
            }
            setQuestion(nextQuestion)
        }
    }
    
    private func setQuestion(_ question: Question) {
        accessControlService?.isUnlocked(question.id) { [weak self] isUnlocked in
            guard let self = self else {
                return
            }
            guard isUnlocked else {
                self.invokeCallback(with: .waitingForNextQuestion)
                return
            }
            self.currentQuestion = question
            self.invokeCallback(with: .question(question.question))
            if let image = question.image {
                self.imagesService?.showImage(questionId: question.id, image: image)
            }
        }
    }
    
    private func setRound(_ round: Round) {
        accessControlService?.isUnlocked(round.id) { [weak self] isUnlocked in
            guard let self = self else {
                return
            }
            guard isUnlocked else {
                self.invokeCallback(with: .waitingForNextRound)
                return
            }
            self.currentRound = round
            self.currentQuestion = nil
            self.invokeCallback(with: .roundStart(round.title))
            if self.advanceAutomatically {
                self.nextQuestion()
            }
        }
    }
    
    public func nextRound() {
        guard let quiz = self.quiz else {
            downloadQuiz(quizURL: quizURL)
            return
        }
        guard let currentRound = self.currentRound else {
            invokeCallback(with: QuizError.noContent)
            return
        }
        guard let roundIndex = quiz.rounds.firstIndex(where: { round in
            round == currentRound
        }) else {
            return
        }
        let nextRoundIndex = roundIndex.advanced(by: 1)
        guard nextRoundIndex != quiz.rounds.endIndex else {
            let rounds: [MarkingSubmissionRound] = quiz.rounds.map { round in
                let answers = round.questions.map { question in
                    return MarkingSubmissionAnswer(question: question.question, answer: self.answers[question.id] ?? [], score: 0, potentialScore: 0)
                }
                return MarkingSubmissionRound(title: round.title, answers: answers)
            }
            let submission = MarkingSubmission(submission: rounds)
            let answersURL = URL(fileURLWithPath: "answers.txt")
            try? submission.description.data(using: .utf8)?.write(to: answersURL)
            if let slackURL = quiz.configuration.markingURL {
                let messagingService = QuizServices.messaging(hookURL: slackURL)
                messagingService.message(submission.description) {
                    self.invokeCallback(with: .quizComplete)
                }
            } else {
                invokeCallback(with: .quizComplete)
            }
            return
        }
        let nextRound = quiz.rounds[nextRoundIndex]
        setRound(nextRound)
    }
    
    /// Note: This method is synchronous.
    public static func packageQuiz(jsonData: Data, key: String?, output: URL) -> PackageQuizResult {
        let parsingService = QuizServices.parsing
        do {
            let model = try parsingService.parse(jsonData)
            let factory = QuizFactory(model: model)
            let quiz = try factory.manufacture()
            let encoder = JSONEncoder()
            var outputData = try encoder.encode(quiz)
            if let key = key?.data(using: .utf8) {
                outputData = EncryptedData(message: outputData, key: key, algorithm: .aes256).data()
            }
            try outputData.write(to: output)
            return .success(())
        } catch let error {
            return .failure(error)
        }
    }
    
    /// Invoke this method after receiving the `quizReady` event.
    public func startQuiz(key: String? = nil) {
        guard let quiz = self.quiz else {
            downloadQuiz(quizURL: quizURL, key: key)
            return
        }
        guard let firstRound = quiz.rounds.first else {
            invokeCallback(with: QuizError.noContent)
            return
        }
        currentRound = firstRound
        currentQuestion = nil
        invokeCallback(with: .roundStart(firstRound.title))
        if advanceAutomatically {
            nextQuestion()
        }
    }
    
    public func processCommand(_ command: Command) {
        switch command {
        case .answer:
            guard let currentQuestion = self.currentQuestion else {
                invokeCallback(with: .message("No question in progress"))
                return
            }
            if let answer = answers[currentQuestion.id] {
                invokeCallback(with: .message("Submitted answer: \(answer)"))
            } else {
                invokeCallback(with: .message("No answer submitted"))
            }
        case .nextQuestion:
            nextQuestion()
        case .nextRound:
            nextRound()
        case .question:
            if let question = currentQuestion {
                invokeCallback(with: .message("Question: \(question.question)"))
            } else {
                invokeCallback(with: .message("No question in progress"))
            }
        case .round:
            if let roundTitle = currentRound?.title {
                invokeCallback(with: .message("Round: \(roundTitle)"))
            } else {
                invokeCallback(with: .message("Round not yet started"))
            }
        case .start:
            startQuiz()
        case .unknown(let input):
            if let quizData = self.quizData, quiz == nil { // Quiz is nil, assume not unpacked due to decryption failure.
                unpackQuiz(quizData: quizData, key: input)
            } else {
                invokeCallback(with: .message("Submitted answer: \(input)"))
                submitAnswer(input)
            }
        }
    }
    
    public func submitAnswer(_ answer: String?) {
        guard let currentQuestion = self.currentQuestion else {
            return
        }
        let submittedAnswers: [String]?
        if let answer = answer {
            submittedAnswers = [answer]
        } else {
             submittedAnswers = nil
        }
        answers[currentQuestion.id] = submittedAnswers
        if advanceAutomatically {
            nextQuestion()
        }
    }
    
    public static func unpackageQuiz(url: URL, key: String?, completion: @escaping(QuizResult) -> Void) {
        do {
            var inputData = try Data(contentsOf: url)
            if let key = key?.data(using: .utf8) {
                inputData = DecryptedData(message: inputData, key: key, algorithm: .aes256).data()
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromKebabCase
            let quiz = try decoder.decode(Quiz.self, from: inputData)
            completion(.success(quiz))
        } catch let error {
            completion(.failure(error))
        }
    }
    
}

private extension SwiftQuiz {
    
    private func attemptQuizUnpack(quizData: Data) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromKebabCase
            let quiz = try decoder.decode(Quiz.self, from: quizData)
            self.quiz = quiz
            self.accessControlService = QuizServices.accessControl(quiz)
            invokeCallback(with: .quizReady)
            if advanceAutomatically {
                startQuiz(key: nil)
            }
        } catch _ {
            invokeCallback(with: .keyRequired)
        }
    }
    
    private func unpackQuiz(quizData: Data, key: String) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromKebabCase
            guard let keyData = key.trimmingCharacters(in: .whitespacesAndNewlines).data(using: .utf8) else {
                return
            }
            let plainTextData = DecryptedData(message: quizData, key: keyData, algorithm: .aes256).data()
            let quiz = try decoder.decode(Quiz.self, from: plainTextData)
            self.quiz = quiz
            self.accessControlService = QuizServices.accessControl(quiz)
            invokeCallback(with: .quizReady)
            if advanceAutomatically {
                startQuiz(key: key)
            }
        } catch let error {
            invokeCallback(with: error)
        }
    }
    
    private func downloadQuiz(quizURL: URL, key: String? = nil) {
        internalQueue.async { [weak self] in
            do {
                self?.quizData = try Data(contentsOf: quizURL)
                if let quizData = self?.quizData {
                    if let key = key {
                        self?.unpackQuiz(quizData: quizData, key: key)
                    } else {
                        self?.attemptQuizUnpack(quizData: quizData)
                    }
                }
            } catch let error {
                self?.invokeCallback(with: error)
            }
        }
    }
    
    private func invokeCallback(with event: QuizEvent) {
        let nextOperation = BlockOperation { [weak self] in
            self?.eventCallback?(event)
        }
        if let previousOperation = previousOperation {
            nextOperation.addDependency(previousOperation)
        }
        queue.addOperation(nextOperation)
        previousOperation = nextOperation
    }
    
    private func invokeCallback(with error: Error) {
        externalQueue.async { [weak self] in
            self?.errorCallback?(error)
        }
    }
    
}
