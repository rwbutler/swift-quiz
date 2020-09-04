//
//  QuizConfiguration.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

struct QuizConfiguration: Codable {
    let markingOccurs: MarkingFrequency
    let markingURL: URL?
    let type: QuizType
}
