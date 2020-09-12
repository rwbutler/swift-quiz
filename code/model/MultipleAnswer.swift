//
//  MultipleAnswer.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

public struct MultipleAnswer: Codable {
    let id: UUID
    let answers: [String]
    let image: Data?
    let question: String
    let scoring: [QuestionScoring]
}

struct QuestionScoring: Codable {
    
    let answerCount: Int?
    let awardsScore: Int
    let awardedFor: Awarding
    
    enum CodingKeys: String, CodingKey {
        case answerCount = "answers"
        case awardsScore = "awards"
        case awardedFor = "awarded-for"
    }
    
    init(answerCount: Int?, awardsScore: Int, awardedFor: Awarding) {
        self.answerCount = answerCount
        self.awardsScore = awardsScore
        self.awardedFor = awardedFor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        answerCount = (try? container.decodeIfPresent(Int.self, forKey: .answerCount))
        awardsScore = (try? container.decodeIfPresent(Int.self, forKey: .awardsScore)) ?? 1
        awardedFor = (try? container.decodeIfPresent(Awarding.self, forKey: .awardedFor)) ?? .allCorrect
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(answerCount, forKey: .answerCount)
        try container.encode(awardsScore, forKey: .awardsScore)
        try container.encode(awardedFor, forKey: .awardedFor)
    }
    
}

enum Awarding: String, Codable {
    case none
    case allCorrect = "all-correct"
    case eachCorrect = "each-correct"
}
