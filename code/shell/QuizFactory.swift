//
//  QuizFactory.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation

struct QuizFactory {
    
    private let model: QuizModel
    
    init(model: QuizModel) {
        self.model = model
    }
    
    private func imageDataSync(url: URL?) throws -> Data? {
        guard let url = url else {
            return nil
        }
        return try Data(contentsOf: url)
    }
    
    func manufacture() throws -> Quiz {
        let rounds: [Round] = try model.rounds.map { roundModel in
            let questions: [Question] = try roundModel.questions.map { questionModel in
                switch questionModel.type {
                case "short-answer":
                    guard let answer = questionModel.answer else {
                        throw PackagingError.questionMissingAnswer
                    }
                    let shortAnswer = ShortAnswer(
                        id: UUID(),
                        answer: answer,
                        image: try imageDataSync(url: questionModel.image),
                        question: questionModel.question
                    )
                    return .shortAnswer(shortAnswer)
                case "multiple-choice":
                    guard let answer = questionModel.answer,
                        let choices = questionModel.choices else {
                            throw PackagingError.multipleChoiceQuestionMissingChoices
                    }
                    let multipleChoice = MultipleChoice(
                        id: UUID(),
                        answer: answer,
                        choices: choices,
                        image: try imageDataSync(url: questionModel.image),
                        question: questionModel.question
                    )
                    return .multipleChoice(multipleChoice)
                case "multiple-answer":
                    guard let answers = questionModel.answers else {
                        throw PackagingError.questionMissingAnswer
                    }
                    let scoring = questionModel.scoring ?? [QuestionScoring(answerCount: nil, awardsScore: 1, awardedFor: .allCorrect)]
                    let multipleAnswer = MultipleAnswer(
                        id: UUID(),
                        answers: answers,
                        image: try imageDataSync(url: questionModel.image),
                        question: questionModel.question,
                        scoring: scoring
                    )
                    return .multipleAnswer(multipleAnswer)
                default:
                    throw PackagingError.invalidQuestionType
                }
            }
            return Round(id: UUID(), title: roundModel.name, questions: questions)
        }
        let quizType: QuizType
        if let flagPoleURL = model.flagPole {
            quizType = .remote(flagPole: flagPoleURL)
        } else {
            quizType = .local
        }
        let configuration = QuizConfiguration(
            marking: model.marking ?? .none,
            markingURL: model.markingUrl,
            type: quizType
        )
        return Quiz(configuration: configuration, rounds: rounds)
    }
    
}
