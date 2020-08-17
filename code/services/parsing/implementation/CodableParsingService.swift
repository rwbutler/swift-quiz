//
//  ParsingService.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//
import Foundation

struct CodableParsingService: ParsingService {
    
    func parse(_ data: Data) throws -> QuizModel {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        return try decoder.decode(QuizModel.self, from: data)
    }
    
}
