import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let numberStream = AsyncStream<Int> { continuation in
    Task {
        for i in 1...240 {
            continuation.yield(i) // Emit the next value
            try await Task.sleep(for: .seconds(1)) // Simulate delay
        }
        continuation.finish() // Indicate the stream is complete
    }
}

// Consume the stream
Task {
    for await number in numberStream {
        print("Received number: \(number)")
    }
    print("Stream finished!")
}
