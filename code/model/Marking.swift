//
//  Marking.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

enum Marking: String, Codable {
    case never
    case atEnd = "at-quiz-end"
    case eachQuestion = "every-question"
    case eachRound = "at-round-end"
}
