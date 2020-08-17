//
//  Quiz.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

public struct Quiz: Codable {
    let configuration: QuizConfiguration
    let rounds: [Round]
}
