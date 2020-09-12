//
//  StringAdditions.swift
//  
//
//  Created by Ross Butler on 11/09/2020.
//

import Foundation

extension String {
    static let empty = ""
    static let newline = "\n"
    static let tab = "\t"
    
    static func newlines(_ count: Int) -> String {
        String(repeating: newline, count: count)
    }
    
    static func tabs(_ count: Int) -> String {
        String(repeating: tab, count: count)
    }
}
