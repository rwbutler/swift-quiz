//
//  QuestionModel.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

struct QuestionModel: Codable {
    let question: String
    let type: String
    let answer: String?
    let answers: [String]?
    let choices: [String]?
    let images: [URL]?
    let image: URL?
    let scoring: QuestionScoring?
    
}
