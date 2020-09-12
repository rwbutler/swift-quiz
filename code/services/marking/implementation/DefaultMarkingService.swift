import Foundation
import Fuse

struct DefaultMarkingService: MarkingService {
    private let fuse = Fuse()
    private let mode: MarkingFrequency
    private let threshold: Double
    
    init(mode: MarkingFrequency, threshold: Double)  {
        self.mode = mode
        self.threshold = threshold
    }
    
    func isCorrect(_ submittedAnswer: String, correctAnswers: [String]) -> Bool {
        let isCorrect = correctAnswers.reduce(false) { (result, correctAnswer) in
            if let searchResult = fuse.search(correctAnswer, in: submittedAnswer) {
                return (searchResult.score <= threshold) || result
            }
            return result
        }
        return isCorrect
    }
    
    func mark(question: Question, answers: [String]) -> MarkingSubmissionAnswer {
        switch question {
        case .shortAnswer(let shortAnswer):
            let potentialScore = UInt(shortAnswer.scoring.awardsScore)
            guard let submittedAnswer = answers.first,
                let score = fuse.search(shortAnswer.answer, in: submittedAnswer)?.score,
                score <= threshold else {
                    return MarkingSubmissionAnswer(question: question.question, answer: [shortAnswer.answer], correctAnswers: question.answers, score: 0, potentialScore: potentialScore)
            }
            return MarkingSubmissionAnswer(question: question.question, answer: [shortAnswer.answer], correctAnswers: question.answers, score: potentialScore, potentialScore: potentialScore)
        case .multipleChoice(let multipleChoice):
            let potentialScore = UInt(multipleChoice.scoring.awardsScore)
            guard let submittedAnswer = answers.first,
                let score = fuse.search(multipleChoice.answer, in: submittedAnswer)?.score,
                score <= threshold else {
                    return MarkingSubmissionAnswer(question: question.question, answer: question.answers, correctAnswers: [multipleChoice.answer], score: 0, potentialScore: potentialScore)
            }
            return MarkingSubmissionAnswer(question: question.question, answer: [multipleChoice.answer], correctAnswers: question.answers, score: potentialScore, potentialScore: potentialScore)
        case .multipleAnswer(let multipleAnswer):
            let scoringRules = multipleAnswer.scoring
            let correctAnswers = multipleAnswer.answers
            let correctAnswerCount = answers.map {
                isCorrect($0, correctAnswers: correctAnswers)
            }.filter { $0 == true }.count
            var score: Int = 0
            var potentialScore: Int = 0
            
            // Iterate scoring criteria
            for scoringRule in scoringRules {
                switch scoringRule.awardedFor {
                case .none:
                    continue
                case .allCorrect:
                    let allCorrect = correctAnswerCount == (scoringRule.answerCount ?? 1)
                    score += allCorrect ? scoringRule.awardsScore : 0
                    potentialScore += scoringRule.awardsScore
                case .eachCorrect:
                    let requiredAnswerCount = scoringRule.answerCount ?? 1
                    score += (correctAnswerCount / requiredAnswerCount) * scoringRule.awardsScore
                    potentialScore += (answers.count / requiredAnswerCount) * scoringRule.awardsScore
                }
            }
            return MarkingSubmissionAnswer(question: question.question, answer: answers, correctAnswers: question.answers, score: UInt(score), potentialScore: UInt(potentialScore))
        }
    }
    
    func mark(round: Round, answers: [QuestionKey: [String]]) -> MarkingSubmissionRound {
        let markedAnswers: [MarkingSubmissionAnswer] = round.questions.map { question in
            let submittedAnswers = answers[question.id] ?? []
            return mark(question: question, answers: submittedAnswers)
        }
        return MarkingSubmissionRound(title: round.title, answers: markedAnswers)
    }
    
    func mark(quiz: Quiz, answers: [QuestionKey: [String]]) -> MarkingSubmission {
        let markedRounds = quiz.rounds.map { round in
            return mark(round: round, answers: answers)
        }
        return MarkingSubmission(submission: markedRounds)
    }
    
}
