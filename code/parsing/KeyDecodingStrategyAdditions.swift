//
//  KeyDecodingStrategyAdditions.swift
//  
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation

struct AnyKey: CodingKey {
    
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
    
}

extension JSONDecoder.KeyDecodingStrategy {
    
    static let convertFromKebabCase = JSONDecoder.KeyDecodingStrategy.custom({ keys in
        guard let lastComponent = keys.last?.stringValue.split(separator: ".").last,
            lastComponent.contains("-") else {
                return keys.last ?? AnyKey(stringValue: "")! // Try to return something non-nil.
        }
        let components = lastComponent.split(separator: "-")
        var result: String
        if let firstComponent = components.first {
            let remainingComponents = components.dropFirst().map {
                $0.capitalized
            }
            result = ([String(firstComponent)] + remainingComponents).joined()
        } else {
            result = String(lastComponent)
        }
        return AnyKey(stringValue: String(result))!
    })
    
}
