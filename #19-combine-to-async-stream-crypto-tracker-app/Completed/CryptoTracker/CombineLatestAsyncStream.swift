import Foundation

/// A utility function that combines the latest values from two `AsyncStream`s 
public extension AsyncStream {
    /// Combines the latest values from `self` and another `AsyncStream` into a single `AsyncStream` of tuples.
    func combineLatest<U>(
        with otherStream: AsyncStream<U>
    ) -> AsyncStream<(Element, U)> {
        AsyncStream<(Element, U)> { continuation in
            var latestValue1: Element?
            var latestValue2: U?
            
            var isTask1Finished = false
            var isTask2Finished = false
            
            let task1 = Task {
                for await value in self {
                    latestValue1 = value
                    if let v1 = latestValue1, let v2 = latestValue2 {
                        continuation.yield((v1, v2))
                    }
                }
                isTask1Finished = true
                if isTask1Finished && isTask2Finished {
                    continuation.finish()
                }
            }
            
            let task2 = Task {
                for await value in otherStream {
                    latestValue2 = value
                    if let v1 = latestValue1, let v2 = latestValue2 {
                        continuation.yield((v1, v2))
                    }
                }
                isTask2Finished = true
                if isTask1Finished && isTask2Finished {
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { _ in
                task1.cancel()
                task2.cancel()
            }
        }
    }
}
