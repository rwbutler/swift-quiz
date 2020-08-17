//
//  Round.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

struct Round: Codable {
    let id: UUID
    let title: String
    let questions: [Question]
}

extension Round: Equatable {
    
    static func == (lhs: Round, rhs: Round) -> Bool {
        lhs.id == rhs.id
    }
    
}
