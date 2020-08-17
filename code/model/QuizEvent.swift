//
//  QuizEvent.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

public enum QuizEvent: Equatable, CustomStringConvertible {
    
    case keyRequired
    case question(_ question: String)
    case quizComplete
    case quizReady
    case message(_ message: String)
    case roundStart(_ title: String)
    case waitingForNextQuestion
    case waitingForNextRound
    
    public var description: String {
        switch self {
        case .keyRequired:
            return "🔑 Please enter the quiz access key:"
        case .question(let question):
            return "❓ Question: '\(question)'"
        case .message(let message):
            return message
        case .quizComplete:
            return "🎉 Quiz complete."
        case .quizReady:
            return "🏁 Quiz ready."
        case .roundStart(let roundTitle):
            return "🆕 Round: '\(roundTitle)'"
        case .waitingForNextQuestion:
            return "⏲ Awaiting next question"
        case .waitingForNextRound:
            return "⏱ Awaiting next round"
        }
    }
    
}
