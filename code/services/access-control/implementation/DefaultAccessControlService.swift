//
//  File.swift
//  
//
//  Created by Ross Butler on 22/07/2020.
//

import Foundation

class DefaultAccessControlService: AccessControlService {
    
    private var quizType: QuizType {
        quiz.configuration.type
    }
    private let quiz: Quiz
    private var acl: [UUID: Bool] = [:]
    private var timer: Timer?
    private var pollingInterval: Double = 5.0
    private var completions: [UUID: (Bool) -> Void] = [:]
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    private func contactFlagpole(url: URL) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromKebabCase
            if let model = try? decoder.decode(Flagpole.self, from: data) {
                self?.updateACLs(with: model.accessToken)
                let identifiers: [UUID] = self?.completions.keys.compactMap { $0 } ?? []
                identifiers.forEach { identifier in
                    let isUnlocked = self?.isUnlockedSync(identifier) == true
                    self?.completions[identifier]?(isUnlocked)
                    if isUnlocked {
                        self?.completions.removeValue(forKey: identifier)
                    }
                }
                if self?.completions.isEmpty ?? true {
                    self?.timer?.invalidate()
                }
            }
        }
        dataTask.resume()
    }
    
    func isUnlocked(_ identifier: UUID, completion: @escaping (Bool) -> Void) {
       guard case .remote = quizType else {
            completion(true)
            return
        }
        let isUnlocked =  acl[identifier] ?? false
        if !isUnlocked {
            completions[identifier] = completion
            let timer = Timer(
                timeInterval: pollingInterval,
                target: self,
                selector: #selector(pollingTimerDidFire),
                userInfo: nil,
                repeats: true
            )
            self.timer = timer
            DispatchQueue.main.async {
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            }
        } else {
            completion(isUnlocked)
        }
    }
    
    private func isUnlockedSync(_ identifier: UUID) ->  Bool {
        guard case .remote = quizType else {
            return true
        }
        return acl[identifier] ?? false
    }
    
    private func enablePreviousRoundsAndQuestions() {
        acl.keys.forEach { key in
            acl[key] = true
        }
    }
    
    @objc func pollingTimerDidFire() {
        guard case .remote(let flagPoleURL) = quizType else {
            return
        }
        contactFlagpole(url: flagPoleURL)
    }
    
    private func updateACLs(with accessToken: UUID) {
        quiz.rounds.forEach { round in
            acl[round.id] = false
            if round.id == accessToken {
                enablePreviousRoundsAndQuestions()
            }
            round.questions.forEach { question in
                acl[question.id] = false
                if question.id == accessToken {
                    enablePreviousRoundsAndQuestions()
                }
            }
        }
    }
    
}
