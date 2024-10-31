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
    
    var timer: MainActorIsolatedTimer?
//    var timer: MyTimerActorIsolatedTimer?

    var isRepeat = true
    var isTimerRunning: Bool { timer != nil }
    var timerText: Date?
    var firedAtText: String = ""
    
    var timerInterval: Double = 3
    var clockType: ClockType = .continuous
    

    func startTimer() {
        stopTimer()
        timerText = .now
        
        startMainActorIsolatedTimer()
//        startMyActorIsolatedTimer()
    }
    
    
    func startMainActorIsolatedTimer() {
        timer = MainActorIsolatedTimer(interval: timerInterval, repeats: isRepeat, clockType: clockType, block: { [weak self] timer in
            print(Thread.current)
            self?.updateUI(isCompleted: !timer.isValid)
        })
    }
//    
//    func startMyActorIsolatedTimer() {
//        self.timer = MyTimerActorIsolatedTimer(interval: timerInterval, repeats: isRepeat, clockType: clockType, block: { [weak self] timer in
//            print(Thread.current)
//            Task { @MainActor in
//                await self?.updateUI(isCompleted: !timer.isValid)
//            }
//        })
//    }
    
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
//        Task { @MyTimerActor in
//            timer.invalidate()
//        }
        self.timer = nil
    }
    
}
