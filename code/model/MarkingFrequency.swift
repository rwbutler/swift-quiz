//
//  MarkingFrequency.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

enum MarkingFrequency: String, Codable {
    case never
    case atEnd = "at-quiz-end"
    case eachQuestion = "every-question"
    case eachRound = "at-round-end"
    
    var shouldDisplayMarkedResultsAfterQuestion: Bool {
        return self == .eachQuestion
    }
    
    var shouldDisplayMarkedResultsAfterRound: Bool {
        return shouldDisplayMarkedResultsAfterQuestion || (self == .eachRound)
    }
    
    var shouldDisplayMarkedResultsAfterGame: Bool {
        return shouldDisplayMarkedResultsAfterRound || (self == .atEnd)
    }
}
