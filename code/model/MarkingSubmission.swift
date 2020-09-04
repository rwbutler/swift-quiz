//
//  MarkingSubmission.swift
//  
//
//  Created by Ross Butler on 13/08/2020.
//

import Foundation

public enum MarkingResult: Equatable {
    case questionResult(_ result: MarkingSubmissionAnswer)
    case roundResult(_ result: MarkingSubmissionRound)
    case gameResult(_ result: MarkingSubmission)
}

extension MarkingResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .questionResult(let result):
            return result.description
        case .roundResult(let result):
            return result.description
        case .gameResult(let result):
            return result.description
        }
    }
}

public struct MarkingSubmission: Codable, Equatable {
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

extension MarkingSubmission: CustomStringConvertible {
    public var description: String {
        var result: String = "📝 Submission\n"
        submission.forEach { round in
            result += "\(round.title)\n"
            for (answerIndex, answer) in round.answers.enumerated() {
                let questionNumber = answerIndex + 1
                let scoreString = "\(answer.score)/\(answer.potentialScore) \(emoji(score: answer.score, potentialScore: answer.potentialScore))"
                result += "\(questionNumber).) \(answer.question)\n\t➡️ Submitted answer: \(answer.answer.joined(separator: ", "))\n\(scoreString)\n"
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
}

public struct MarkingSubmissionRound: Codable, Equatable {
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

extension MarkingSubmissionRound: CustomStringConvertible {
    public var description: String {
        var result: String = "📝 Submission\n"
        result += "\(title)\n"
        for (answerIndex, answer) in answers.enumerated() {
            let questionNumber = answerIndex + 1
            let scoreString = "\(answer.score)/\(answer.potentialScore) \(emoji(score: answer.score, potentialScore: answer.potentialScore))"
            result += "\(questionNumber).) \(answer.question)\n\t➡️ Submitted answer: \(answer.answer.joined(separator: ", "))\n\(scoreString)\n"
        }
        if totalPotentialScore != 0 {
            result += "\nRound score: \(totalScore)/\(totalPotentialScore)\n\n"
        }
        return result
    }
}

public struct MarkingSubmissionAnswer: Codable, Equatable {
    let question: String
    let answer: [String]
    let correctAnswers: [String]
    let score: UInt
    let potentialScore: UInt
}

extension MarkingSubmissionAnswer: CustomStringConvertible {
    public var description: String {
        let scoreString = "\(score)/\(potentialScore) \(emoji(score: score, potentialScore: potentialScore))"
        return "\(question)\n\t➡️ Submitted answer: \(answer.joined(separator: ", "))\n\t➡️ Correct answer: \(correctAnswers.joined(separator: ", "))\n\(scoreString)\n"
    }
}

func emoji(score: UInt, potentialScore: UInt) -> String {
    if score == potentialScore {
        return "✅"
    } else if score == 0 {
        return "❌"
    } else {
        return "☑️"
    }
}
