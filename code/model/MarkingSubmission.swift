//
//  MarkingSubmission.swift
//  
//
//  Created by Ross Butler on 13/08/2020.
//

import Foundation

struct MarkingSubmission: Codable {
    let submission: [MarkingSubmissionRound]
}

struct MarkingSubmissionRound: Codable {
    let title: String
    let answers: [MarkingSubmissionAnswer]
}

struct MarkingSubmissionAnswer: Codable {
    let question: String
    let answer: [String]
}

extension MarkingSubmission: CustomStringConvertible {
    var description: String {
        var result: String = "Submission\n"
        submission.forEach { round in
            result += "\(round.title)\n"
            round.answers.forEach { answer in
                result += "\(answer.question)\n\(answer.answer.joined(separator: ", "))\n"
            }
        }
        return result
    }
}
