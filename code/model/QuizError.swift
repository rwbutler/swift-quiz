//
//  QuizError.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

public enum QuizError: Error {
    case emptyRound // A round started with no questions
    case internalError // A logic error has occurred
    case noContent // Quiz package has no content
    case underlyingError(_ error: Error)
}
