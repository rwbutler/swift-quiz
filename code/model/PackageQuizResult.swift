//
//  PackageQuizResult.swift
//  
//
//  Created by Ross Butler on 07/09/2020.
//

import Foundation

extension SwiftQuiz.PackageQuizResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success:
            return "Quiz successfully packaged."
        case .failure(let error):
            return "Unable to package quiz due to the following error: \(error.localizedDescription)."
        }
    }
}
