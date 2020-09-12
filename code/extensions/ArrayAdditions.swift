//
//  ArrayAdditions.swift
//  
//
//  Created by Ross Butler on 12/09/2020.
//

import Foundation

extension Array {
    enum ElementCount: RawRepresentable {
        typealias RawValue = Int
        
        case none
        case one
        case many(_ elementCount: Int)
        
        var rawValue: Int {
            switch self {
            case .none:
                return 0
            case .one:
                return 1
            case .many(let elementCount):
                return elementCount
            }
        }
        
        init?(rawValue: Int) {
            switch rawValue {
            case 0:
                self = .none
            case 1:
                self = .one
            default:
                self = .many(rawValue)
            }
        }
    }
    
    var elementCount: ElementCount {
        return ElementCount(rawValue: count) ?? .none
    }
}

extension Array where Element == String {
    func containsAnswers() -> Bool {
        return contains {
            $0 != ""
        }
    }
}
