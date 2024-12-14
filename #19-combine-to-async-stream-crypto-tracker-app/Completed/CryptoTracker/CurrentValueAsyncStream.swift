//
//  CurrentValueAsyncStream.swift
//  CryptoTracker
//
//  Created by Alfian Losari on 14/12/24.
//

import Foundation

class CurrentValueAsyncStream<T> {
    private var currentValue: T
    private var continuation: AsyncStream<T>.Continuation?

    init(initialValue: T) {
        self.currentValue = initialValue
    }

    private(set) lazy var stream: AsyncStream<T> = {
        AsyncStream { continuation in
            self.continuation = continuation
            continuation.yield(currentValue)
        }
    }()

    func updateValue(_ newValue: T) {
        currentValue = newValue
        continuation?.yield(newValue)
    }

    func getCurrentValue() -> T {
        return currentValue
    }

    func finish() {
        continuation?.finish()
    }
}
