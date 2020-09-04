//
//  Services.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//
import Foundation

public struct QuizServices {
    
    public static let markingThreshold: Double = 0.15
    
    public static func accessControl(_ quiz: Quiz) -> AccessControlService {
        return DefaultAccessControlService(quiz: quiz)
    }
    
    public static var parsing: ParsingService {
        return CodableParsingService()
    }
    
    static func marking(mode: MarkingFrequency, threshold: Double) -> MarkingService {
        return DefaultMarkingService(mode: mode, threshold: threshold)
    }
    
    static func messaging(hookURL: URL) -> MessagingService {
        return SlackMessagingService(hookURL: hookURL)
    }
    
}
