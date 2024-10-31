//
//  ContentView.swift
//  TaskTimer
//
//  Created by Alfian Losari on 29/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm = ViewModel()
    
    var body: some View {
        VStack {
            Text(vm.firedAtText).font(.headline)
            
            if let timerStart = vm.timerText {
                Text(timerStart, style: .timer)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding()
            }

            HStack {
                #if os(iOS)
                Text("Clock Type")
                #endif
                
                Picker("Clock Type", selection: $vm.clockType) {
                    ForEach(ClockType.allCases) { clock in
                        Text(clock.rawValue).tag(clock)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            HStack {
                Text("Time Interval")
                Slider(value: $vm.timerInterval, in: 1...120)
                    .padding()
                Text("\(Int(vm.timerInterval)) s")
            }.disabled(vm.isTimerRunning)
            
            Toggle("Repeats", isOn: $vm.isRepeat)
                .toggleStyle(SwitchToggleStyle())
                .disabled(vm.isTimerRunning)
                .padding()
            
            HStack {
                Button("Start Timer") {
                    vm.startTimer()
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isTimerRunning)
                
                Button("Stop") {
                    vm.stopTimer()
                }
                .tint(.red)
                .buttonStyle(.borderedProminent)
                .disabled(!vm.isTimerRunning)
                
            }
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}
