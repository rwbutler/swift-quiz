//
//  QuizSubscription.swift
//  
//
//  Created by Ross Butler on 06/09/2020.
//

#if canImport(Combine)
import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class QuizSubscription<S: Subscriber>: Subscription where S.Input == QuizEvent, S.Failure == QuizError {
    private let quiz: SwiftQuiz
    private var subscriber: S?

    init(url: URL, key: String?, subscriber: S) {
        self.quiz = SwiftQuiz(url: url)
        self.subscriber = subscriber
        startQuiz(key: key)
    }
    
    func cancel() {
        subscriber?.receive(completion: Subscribers.Completion<QuizError>.finished)
        subscriber = nil
    }

    func request(_: Subscribers.Demand) {}
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension QuizSubscription {
    
    private func startQuiz(key: String?) {
        quiz.eventCallbacks.append(handleEvent(_:))
        quiz.errorCallbacks.append(handleError(_:))
        quiz.startQuiz(key: key)
    }
    
    private func handleEvent(_ event: QuizEvent) {
        _ = subscriber?.receive(event)
    }
    
    private func handleError(_ error: QuizError) {
        _ = subscriber?.receive(completion: Subscribers.Completion<QuizError>.failure(error))
    }
    
}
#endif
