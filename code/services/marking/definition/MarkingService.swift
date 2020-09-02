//
//  MarkingService.swift
//  
//
//  Created by Ross Butler on 01/09/2020.
//

import Foundation

protocol MarkingService {
    func mark(question: Question, answers: [String]) -> MarkingSubmissionAnswer
}
