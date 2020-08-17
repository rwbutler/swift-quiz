//
//  QuizType.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

enum QuizType: Codable {
    
    case local
    case remote(flagPole: URL)
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let url = try? container.decode(URL.self, forKey: .url) {
            self = .remote(flagPole: url)
        } else {
            self = .local
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .local:
            break
        case .remote(let flagPole):
            try container.encodeIfPresent(flagPole, forKey: .url)
        }
    }
    
}
