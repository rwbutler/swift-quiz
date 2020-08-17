//
//  ParsingService.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//
import Foundation

public protocol ParsingService {
    func parse(_ data: Data) throws -> QuizModel
}
