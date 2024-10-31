//
//  ViewModel.swift
//  TaskTimer
//
//  Created by Alfian Losari on 29/10/24.
//

import Foundation
import Observation

@Observable
@MainActor
class ViewModel {
    
    var timer: Timer?

    var isRepeat = true
    var isTimerRunning: Bool { timer != nil }
    var timerText: Date?
    var firedAtText: String = ""
    
    var timerInterval: Double = 3
    var clockType: ClockType = .continuous

    func startTimer() {
        stopTimer()
        timerText = .now
        startNSTimer()
    }
    
    func startNSTimer() {
        let isCompleted = self.isRepeat
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: self.isRepeat, block: { [weak self] _ in
            print(Thread.current)
            Task { @MainActor in
                self?.updateUI(isCompleted: !isCompleted)
            }
        })
    }

    func updateUI(fireDate: Date = .now, isCompleted: Bool) {
        if isCompleted {
            stopTimer()
        } else {
            firedAtText = "Last Fired At: \(fireDate)"
            timerText = fireDate
        }
    }
    
    func stopTimer() {
        timerText = nil

        guard let timer = self.timer else { return }
        timer.invalidate()
        self.timer = nil
    }
    
    
}
