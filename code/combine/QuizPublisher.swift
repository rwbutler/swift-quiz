//
//  QuizPublisher.swift
//  
//
//  Created by Ross Butler on 06/09/2020.
//

#if canImport(Combine)
import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct QuizPublisher: Publisher {
    
    // MARK: - Type Definitions
    public typealias Failure = QuizError
    public typealias Output = QuizEvent
    
    // MARK: State
    private let key: String?
    private let url: URL
    
    public init(url: URL, key: String? = nil) {
        self.key = key
        self.url = url
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = QuizSubscription(url: url, key: key, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
#endif
