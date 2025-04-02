//
//  WorkoutTimerView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

enum TimerState {
    case ended
    case active
    case stop
    case none
}

struct WorkoutTimerView: View {
    @State var key: String = "Rest for 3min"
    @State var duration: String = "03:00"
    @State var state: TimerState = .active
    
    let time:Int
    
    @StateObject var stopwatch = WorkoutTimerManager()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(key)
                .style(size: .x22, weight: .w800)
            Text(stopwatch.formattedElapsedTime())
                .style(color: timerColor(),
                       size: .x55,
                       weight: .w800)
            StandardButton(title: "Start Timer")  {
                stopwatch.startTimer()
            }.padding(.top)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                if stopwatch.isRunning {
                    stopwatch.continueTimer()
                }
            } else if newPhase == .background {
                stopwatch.storeData()
            }
        }
        .sensoryFeedback(trigger: stopwatch.didHitMark) { old, new in
                .impact(flexibility: .solid, intensity: 1)
        }
        .task {
            stopwatch.timeGoal = TimeInterval(time)
        }
    }
    
    fileprivate func timerColor() -> Color {
        switch state {
        case .ended: Theme.shared.darkText
        case .active: Theme.shared.blue
        case .stop: Theme.shared.placeholderGray
        case .none: Theme.shared.darkText
            
        }
    }
}

#Preview {
    WorkoutTimerView(time: 30)
}



class WorkoutTimerManager: ObservableObject {
    
    enum WorkoutType {
        case countdown
        case stopwatch
        case none
    }
    
    // Timer object to track elapsed time
    var stopwatchTimer: Timer?
    
    // Variable to keep track of elapsed time
    @Published var elapsedTime: TimeInterval = 0
    @Published var timeGoal: TimeInterval = 10
    @Published var isRunning: Bool = false
    @Published var didHitMark: Bool = false
    @Published var type: WorkoutType = .countdown
    
    func startTimer() {
        if !isRunning {
            isRunning.toggle()
            runTimer()
        }
    }
    
    func runTimer() {
        stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            if type == .countdown {
                self.elapsedTime -= 1
                if self.elapsedTime <= 0 {
                    didHitMark.toggle()
                    self.stop()
                }
            } else {
                self.elapsedTime += timer.timeInterval
                if self.elapsedTime == timeGoal {
                    didHitMark.toggle()
                    self.stop()
                }
            }
            
        })
    }
    
    func continueTimer() {
        updateSinceLastTime()
    }
    
    func stop() {
        stopwatchTimer?.invalidate()
    }
    
    func pause() {
        stopwatchTimer?.invalidate()
    }
    
    func formattedElapsedTime() -> String {
        // Format the elapsed time as a stopwatch time
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        
        // Return the formatted time
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateSinceLastTime() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("WorkoutTimer.plist")
            if let data = try? Data(contentsOf: fileURL) {
                do {
                    let plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                    if let dict = plistData as? [String: Any] {
                        // Access Plist data here
                        if let backgroundDate = dict["timer"] as? Date {
                            
                            let timeInBackground = Date().timeIntervalSince(backgroundDate)
                            
                            self.elapsedTime -= timeInBackground
                            
                            self.runTimer()
                        }
                    }
                } catch {}
            }
        }
    }
    
    fileprivate func storeData() {
        stop()
        let data: [String: Any] = [
            "timer": Date()
        ]
        
        if let plistData = try? PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0) {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("WorkoutTimer.plist")
                do {
                    try plistData.write(to: fileURL)
                } catch {}
            }
        }
    }
}


struct CountdownTimerView: View {
    @State private var timeRemaining: CGFloat = 0 // Countdown time in seconds
    @State private var isRunning: Bool = false // Tracks whether the timer is running
    @State private var timer: Timer? = nil
    let totalTime: CGFloat
    
    init(timeRemaining: CGFloat? = nil, isRunning: Bool = false, timer: Timer? = nil, totalTime: CGFloat) {
        self.timeRemaining = totalTime
        self.isRunning = isRunning
        self.timer = timer
        self.totalTime = totalTime
    }
    
    var body: some View {
        VStack {
            ZStack {
                // Background circle (full)
                Circle()
                    .stroke(lineWidth: 22)
                    .opacity(0.3)
                    .foregroundColor(Theme.shared.mediumBlack)
                    .frame(width: 230, height: 230)
                
                // Foreground circle (progress)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                          stops: [
                              Gradient.Stop(color: Theme.shared.orangeGradientColor.primary, location: 0.00),
                            Gradient.Stop(color: Theme.shared.orangeGradientColor.secondary, location: 1.00),
                          ],
                          startPoint: UnitPoint(x: 0.5, y: 0),
                          endPoint: UnitPoint(x: 0.5, y: 1)
                        ),
                        style: StrokeStyle(lineWidth: 22, lineCap: .square)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 230, height: 230)
                    .animation(.linear, value: progress)
                
                // Display the remaining time
                Text(formattedElapsedTime())
                    .style(color:.white, size: .huge, weight: .w800)
            }
            // Pause/Resume Button
            Button(action: {
                if isRunning {
                    pauseCountdown()
                } else {
                    startCountdown()
                }
            }) {
                HStack {
                    if isRunning {
                        Image.pause
                            .renderingMode(.template)
                            .foregroundColor(Theme.shared.orange)
                    } else {
                        Image.playFill
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                    
                    Text(isRunning ? "PAUSE" : "START")
                        .style(color: isRunning ? Theme.shared.orange : .white,
                               size: .regular,
                               weight: .w700)
                }
                .padding()
            }
            .background(Capsule().fill(isRunning ? Theme.shared.mediumBlack : Theme.shared.green))
            .padding(.top, 30)
        }
        .onDisappear {
            timer?.invalidate() // Stop the timer when view disappears
        }
    }
    
    func formattedElapsedTime() -> String {
        // Format the elapsed time as a stopwatch time
        let minutes = Int(timeRemaining) / 60 % 60
        let seconds = Int(timeRemaining) % 60
        
        // Return the formatted time
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Calculate progress as a percentage of the total time
    var progress: CGFloat {
        return (totalTime - timeRemaining) / totalTime
    }
    
    // Start the countdown timer
    func startCountdown() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    // Pause the countdown timer
    func pauseCountdown() {
        isRunning = false
        timer?.invalidate() // Stop the timer without resetting the time
    }
}
