//
//  QuizModel.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 18/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

public struct QuizModel: Codable {
    let flagPole: URL?
    let title: String
    let marking: MarkingFrequency?
    let markingUrl: URL?
    let rounds: [RoundModel]
}
