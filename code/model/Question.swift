//
//  Question.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

enum Question: Codable {
        
    case multipleAnswer(_ multipleAnswer: MultipleAnswer)
    case multipleChoice(_ multipleChoice: MultipleChoice)
    case shortAnswer(_ shortAnswer: ShortAnswer)
    
    enum CodingKeys: String, CodingKey {
        case question
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let multipleAnswer = try? container.decode(MultipleAnswer.self, forKey: .question) {
            self = .multipleAnswer(multipleAnswer)
        } else if let multipleChoice = try? container.decode(MultipleChoice.self, forKey: .question) {
            self = .multipleChoice(multipleChoice)
        } else if let shortAnswer = try? container.decode(ShortAnswer.self, forKey: .question) {
            self = .shortAnswer(shortAnswer)
        } else {
            throw CodableError.decodingFailure
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .multipleAnswer(let multipleAnswer):
            try container.encode(multipleAnswer, forKey: .question)
        case .multipleChoice(let multipleChoice):
            try container.encode(multipleChoice, forKey: .question)
        case .shortAnswer(let shortAnswer):
            try container.encode(shortAnswer, forKey: .question)
        }
    }
    
    var id: UUID {
        switch self {
        case .multipleAnswer(let multipleAnswer):
            return multipleAnswer.id
        case .multipleChoice(let multipleChoice):
            return multipleChoice.id
        case .shortAnswer(let shortAnswer):
            return shortAnswer.id
        }
    }
    
    var question: String {
        switch self {
        case .multipleAnswer(let multipleAnswer):
            return multipleAnswer.question
        case .multipleChoice(let multipleChoice):
            return multipleChoice.question
        case .shortAnswer(let shortAnswer):
            return shortAnswer.question
        }
    }
    
    var answers: [String] {
        switch self {
        case .multipleAnswer(let multipleAnswer):
            return multipleAnswer.answers
        case .multipleChoice(let multipleChoice):
            return [multipleChoice.answer]
        case .shortAnswer(let shortAnswer):
            return [shortAnswer.answer]
        }
    }
    
    var image: Data? {
        switch self {
        case .multipleAnswer(let multipleAnswer):
            return multipleAnswer.image
        case .multipleChoice(let multipleChoice):
            return multipleChoice.image
        case .shortAnswer(let shortAnswer):
            return shortAnswer.image
        }
    }
    
}

extension Question: Equatable {
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.id == rhs.id
    }

}
