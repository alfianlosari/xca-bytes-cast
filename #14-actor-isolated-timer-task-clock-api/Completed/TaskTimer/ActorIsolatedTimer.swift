//
//  Timer.swift
//  TaskTimer
//
//  Created by Alfian Losari on 29/10/24.
//

import Foundation

@MainActor
class MainActorIsolatedTimer {
    
    private var task: Task<Void, Never>? = nil
    private(set) var isValid = true

    nonisolated init(interval: TimeInterval, repeats: Bool, clockType: ClockType = .continuous, block: @escaping @Sendable @MainActor (MainActorIsolatedTimer) -> Void)  {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.task = Task { [weak self] in
                guard let self else { return }
                var isRunning = true
                repeat {
                    do {
                        let nanoSeconds = UInt64(interval * 1_000_000_000)
                        if clockType == .continuous {
                            let clock = ContinuousClock()
                            try await clock.sleep(until: .now + .nanoseconds(nanoSeconds), tolerance: .zero)
                        } else {
                            let clock = SuspendingClock()
                            try await clock.sleep(until: .now + .nanoseconds(nanoSeconds), tolerance: .zero)
                        }
                    
                        try Task.checkCancellation()
                        isRunning = repeats
                        if !isRunning {
                            self.invalidate()
                        }
                        
                        Task { [weak self] in
                            guard let self else { return }
                            block(self)
                        }
                    } catch {
                        if error is CancellationError {
                            print("Timer is cancelled")
                        }
                        isRunning = false
                        self.invalidate()
                    }
                } while isRunning
            }
        }
    }

    func invalidate() {
        isValid = false
        task?.cancel()
    }
}


@globalActor
actor MyTimerActor {
    static let shared = MyTimerActor()
}

@MyTimerActor
class MyTimerActorIsolatedTimer {
    
    private var task: Task<Void, Never>? = nil
    private(set) var isValid = true

    nonisolated init(interval: TimeInterval, repeats: Bool, clockType: ClockType = .continuous, block: @escaping @Sendable @MyTimerActor (MyTimerActorIsolatedTimer) -> Void)  {
        Task { @MyTimerActor in
            self.task = Task { [weak self] in
                guard let self else { return }                
                var isRunning = true
                repeat {
                    do {
                        let nanoSeconds = UInt64(interval * 1_000_000_000)
                        if clockType == .continuous {
                            let clock = ContinuousClock()
                            try await clock.sleep(until: .now + .nanoseconds(nanoSeconds), tolerance: .zero)
                        } else {
                            let clock = SuspendingClock()
                            try await clock.sleep(until: .now + .nanoseconds(nanoSeconds), tolerance: .zero)
                        }
                        try Task.checkCancellation()
                        isRunning = repeats
                        if !isRunning {
                            self.invalidate()
                        }
                        
                        Task { [weak self] in
                            guard let self else { return }
                            block(self)
                        }
                    } catch {
                        if error is CancellationError {
                            print("Timer is cancelled")
                        }
                        isRunning = false
                        self.invalidate()
                    }
                } while isRunning
            }
        }
    }
    
    func invalidate() {
        isValid = false
        task?.cancel()
    }
    
}
