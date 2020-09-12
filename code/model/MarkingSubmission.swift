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
            result += round.description
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
        var result = "\(title)\n"
        for (answerIndex, answer) in answers.enumerated() {
            let questionNumber = answerIndex + 1
            result += "\(questionNumber).) \(answer.description)"
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
        let submittedAnswerStr = submittedAnswerString()
        let correctAnswersStr = correctAnswerString(for: correctAnswers, score: score, outOf: potentialScore)
        return "\(question)\(submittedAnswerStr)\(correctAnswersStr)\(String.newline)\(scoreString)\(String.newline)"
    }
    
    var indentedNewline: String {
        return "\(String.newline)\(String.tab)➡️ "
    }
    private func correctAnswerString(for correctAnswers: [String], score: UInt, outOf potentialScore: UInt) -> String {
        guard shouldShowCorrectAnswer(score: score, outOf: potentialScore) else {
            return String.empty
        }
        var prefix: String = indentedNewline
        switch correctAnswers.elementCount {
        case .none:
            return String.empty
        case .one:
            prefix += "Correct answer: "
        case .many:
            prefix += "Correct answers: "
        }
        return "\(prefix)\(correctAnswers.joined(separator: ", "))"
    }
    
    private func shouldShowCorrectAnswer(score: UInt, outOf potentialScore: UInt) -> Bool {
        return score != potentialScore
    }
    
    private func submittedAnswerString() -> String {
        let prefix: String = "\(indentedNewline)Submitted answer: "
        if answer.containsAnswers() {
            return "\(prefix)\(answer.joined(separator: ", "))"
        } else {
            return "\(prefix)- PASS -"
        }
    }
}

func emoji(score: UInt, potentialScore: UInt) -> String {
    guard potentialScore != 0 else {
        return String.empty
    }
    if score == potentialScore {
        return "✅"
    } else if score == 0 {
        return "❌"
    } else {
        return "☑️"
    }
}
