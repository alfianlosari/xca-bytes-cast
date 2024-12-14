import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// A Combine subject to publish values
let subject = PassthroughSubject<Int, Never>()

// Subscribe to the subject and use Combine operators
let cancellable = subject
    .map { $0 * 2 }         // Multiply each value by 2
    .filter { $0 % 3 == 0 } // Only pass values divisible by 3
    .sink { value in
        print("Received value: \(value)")
    }

// Simulate value emission with Task.sleep
Task {
    for i in 1...240 {
        subject.send(i)
        try await Task.sleep(for: .seconds(1)) // Simulate delay between values
    }
    subject.send(completion: .finished) // Complete the stream
}
