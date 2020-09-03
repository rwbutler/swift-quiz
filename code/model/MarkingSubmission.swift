//
//  MarkingSubmission.swift
//  
//
//  Created by Ross Butler on 13/08/2020.
//

import Foundation

struct MarkingSubmission: Codable {
    let submission: [MarkingSubmissionRound]
    var totalScore: UInt {
        return submission.reduce(0) { (result, roundSubmission) in
            return roundSubmission.totalScore + result
        }
    }
    var totalPotentialScore: UInt {
        return submission.reduce(0) { (result, roundSubmission) in
            return roundSubmission.totalPotentialScore + result
        }
    }
}

struct MarkingSubmissionRound: Codable {
    let title: String
    let answers: [MarkingSubmissionAnswer]
    
    var totalScore: UInt {
        return answers.reduce(0) { (result, answer) in
            return answer.score + result
        }
    }
    var totalPotentialScore: UInt {
        return answers.reduce(0) { (result, answer) in
            return answer.potentialScore + result
        }
    }
}

struct MarkingSubmissionAnswer: Codable {
    let question: String
    let answer: [String]
    let score: UInt
    let potentialScore: UInt
}

extension MarkingSubmission: CustomStringConvertible {
    var description: String {
        var result: String = "📝 Submission\n"
        submission.forEach { round in
            result += "\(round.title)\n"
            for (answerIndex, answer) in round.answers.enumerated() {
                let scoreString = "\(answer.score)/\(answer.potentialScore) \(emoji(score: answer.score, potentialScore: answer.potentialScore))"
                result += "\(answerIndex).) \(answer.question)\n\t➡️ Submitted answer: \(answer.answer.joined(separator: ", "))\n\(scoreString)\n"
            }
            if round.totalPotentialScore != 0 {
                result += "\nRound score: \(round.totalScore)/\(round.totalPotentialScore)\n\n"
            }
        }
        if totalPotentialScore != 0 {
            result += "\n\nTotal score: \(totalScore)/\(totalPotentialScore)\n"
        }
        return result
    }
    
    private func emoji(score: UInt, potentialScore: UInt) -> String {
        if score == potentialScore {
            return "✅"
        } else if score == 0 {
            return "❌"
        } else {
            return "☑️"
        }
    }
}
