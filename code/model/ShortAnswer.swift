//
//  ShortAnswer.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

public struct ShortAnswer: Codable {
    let id: UUID
    let answer: String
    let image: Data?
    let question: String
}
