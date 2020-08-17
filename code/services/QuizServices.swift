//
//  Services.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//
import Foundation

public struct QuizServices {
    
    public static var parsing: ParsingService {
        return CodableParsingService()
    }
    
    public static func accessControl(_ quiz: Quiz) -> AccessControlService {
        return DefaultAccessControlService(quiz: quiz)
    }
    
}
