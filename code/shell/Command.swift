//
//  Command.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation

public enum Command: RawRepresentable {
    
    public typealias RawValue = String
    
    case answer
    case nextQuestion
    case nextRound
    case start
    case question
    case round
    case unknown(_ argument: String)
    
    public init(rawValue: String) {
        switch rawValue {
        case "answer":
            self = .answer
        case "question":
            self = .question
        case "round":
            self = .round
        case "next-question":
            self = .nextQuestion
        case "next-round":
            self = .nextRound
        case "start":
            self = .start
        default:
            self = .unknown(rawValue)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .answer:
            return "answer"
        case .question:
            return "question"
        case .nextQuestion:
            return "next-question"
        case .nextRound:
            return "next-round"
        case .round:
            return "round"
        case .unknown(let answer):
            return answer
        case .start:
            return "start"
        }
    }
}
