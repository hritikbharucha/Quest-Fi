//
//  ActualTimerViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/22/21.
//

import UIKit
import Firebase
import AVFoundation

class ActualTimerViewController: UIViewController {

    @IBOutlet weak var goStopView: UIView!
    
    @IBOutlet weak var goStopButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var totalTimerLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
//    var userID = ""
    
    var current = 0
    
    var sections = 0
    var willHaveLongBreak = false
    
    var totalSeconds = 0
    var totalTimer = Timer()
    var isTotalTimeRunning = false
    
    var seconds = 1500
    var timer = Timer()
    var isTimeRunning = false
    
    var breakSeconds = 300
    var breakTimer = Timer()
    var isBreakTimeRunning = false
    
    var longBreakSeconds = 900
    var longBreakTimer = Timer()
    var isLongBreakTimeRunning = false
    
    var shortWorkSeconds = 1200
    var shortWorkTimer = Timer()
    var isShortWorkTimeRunning = false
    
    var audio: AVAudioPlayer?
    var alert = UIAlertController()
    var breakAlert = UIAlertController()
    var finishAlert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Timer").getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["Error" : "Error"]
                    
                    let length = dataDescription["Length"] as! Int
                    
                    self.totalSeconds = length * 3600
                    
                    self.totalTimerLabel.text = "Time left: \(length):00:00"
                    
                    if length == 1 {
                        self.sections = 4
                    } else if length == 2 {
                        self.sections = 8
                    } else if length == 3 {
                        self.sections = 11
                        self.willHaveLongBreak = true
                    }
                }
            }
        }

        makeButtonGood(goStopButton, goStopView)
        goStopButton.backgroundColor = UIColor.green
        
        
        let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3")
        audio = try? AVAudioPlayer.init(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)
        audio?.numberOfLoops = 1
        
        alert = UIAlertController(title: "Work time's up!", message: "Time to take a break.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.audio?.stop()
        }))
        
        breakAlert = UIAlertController(title: "Break time's up!", message: "Time to resume working.", preferredStyle: UIAlertController.Style.alert)
        breakAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.audio?.stop()
        }))
        
        finishAlert = UIAlertController(title: "Session completed!", message: "Hooray! You completed the session!", preferredStyle: UIAlertController.Style.alert)
        finishAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.audio?.stop()
        }))
        
        
    }
    
    func runTotalTimer() {
        totalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTotalTimer)), userInfo: nil, repeats: true)
        isTotalTimeRunning = true
    }
    
    @objc func updateTotalTimer() {
        if totalSeconds < 1 {
            totalTimer.invalidate()
            goStopPressed(goStopButton)
            textLabel.text = "Congratulations you have completed the session!"
        } else {
            totalSeconds -= 1
            totalTimerLabel.text = totalTimeString(time: TimeInterval(totalSeconds))
        }
    }
    
    func totalTimeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return "Time left: " + String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        current = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        isTimeRunning = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            
            audio?.play()
            self.present(alert, animated: true, completion: nil)
            sections -= 1
            
            if willHaveLongBreak && sections == 4 {
                longBreakSeconds = 7
                runLongBreakTimer()
                textLabel.text = "Take a break!"
            } else if sections > 0 {
                breakSeconds = 5
                runBreakTimer()
                textLabel.text = "Take a break!"
            }
            
            
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            timerLabel.font = UIFont(name: "Times New Roman", size: 125)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func runBreakTimer() {
        current = 1
        breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateBreakTimer)), userInfo: nil, repeats: true)
        isBreakTimeRunning = true
    }
    
    @objc func updateBreakTimer() {
        if breakSeconds < 1 {
            breakTimer.invalidate()
            
            audio?.play()
            sections -= 1
            
            if sections == 0 {
                self.present(finishAlert, animated: true, completion: nil)
            } else {
                self.present(breakAlert, animated: true, completion: nil)
            }
            
            if willHaveLongBreak && sections == 1 {
                shortWorkSeconds = 10
                runShortWorkTimer()
                textLabel.text = "Work time!"
            } else if sections > 0 {
                seconds = 15
                runTimer()
                textLabel.text = "Work time!"
            }
            
        } else {
            breakSeconds -= 1
            timerLabel.text = breakTimeString(time: TimeInterval(breakSeconds))
            timerLabel.font = UIFont(name: "Times New Roman", size: 125)
        }
    }
    
    func breakTimeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func runLongBreakTimer() {
        current = 2
        longBreakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateLongBreakTimer)), userInfo: nil, repeats: true)
        isLongBreakTimeRunning = true
    }
    
    @objc func updateLongBreakTimer() {
        if longBreakSeconds < 1 {
            longBreakTimer.invalidate()
            
            audio?.play()
            self.present(breakAlert, animated: true, completion: nil)
            sections -= 1
            if sections > 0 {
                textLabel.text = "Work time!"
                seconds = 15
                runTimer()
            }
            
        } else {
            longBreakSeconds -= 1
            timerLabel.text = longBreakTimeString(time: TimeInterval(longBreakSeconds))
            timerLabel.font = UIFont(name: "Times New Roman", size: 125)
        }
    }
    
    func longBreakTimeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func runShortWorkTimer() {
        current = 3
        shortWorkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateShortWorkTimer)), userInfo: nil, repeats: true)
        isShortWorkTimeRunning = true
    }
    
    @objc func updateShortWorkTimer() {
        if shortWorkSeconds < 1 {
            shortWorkTimer.invalidate()
            
            audio?.play()
            self.present(finishAlert, animated: true, completion: nil)
            
            sections -= 1
            
            if sections > 0 {
                runBreakTimer()
            } 
            
        } else {
            shortWorkSeconds -= 1
            timerLabel.text = shortWorkTimeString(time: TimeInterval(shortWorkSeconds))
            timerLabel.font = UIFont(name: "Times New Roman", size: 125)
        }
    }
    
    func shortWorkTimeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 20).cgPath
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
    }

    @IBAction func goStopPressed(_ sender: UIButton) {
        
        if goStopButton.backgroundColor == UIColor.green {
            
            //Begin timer here
            
            goStopButton.backgroundColor = UIColor.red
            goStopButton.setTitle("Stop", for: .normal)
            
            if isTotalTimeRunning == false {
                runTotalTimer()
            }
            
            if current == 0 {
                if isTimeRunning == false {
                    runTimer()
                }
            } else if current == 1 {
                if isBreakTimeRunning == false {
                    runBreakTimer()
                }
            } else if current == 2 {
                if isLongBreakTimeRunning == false {
                    runLongBreakTimer()
                }
            } else if current == 3 {
                if isShortWorkTimeRunning == false {
                    runShortWorkTimer()
                }
            }
            
        } else {
            
            //Stop timer here
            
            goStopButton.backgroundColor = UIColor.green
            goStopButton.setTitle("Go", for: .normal)
            
            if isTotalTimeRunning {
                totalTimer.invalidate()
                isTotalTimeRunning = false
            }
            
            if current == 0 {
                timer.invalidate()
                isTimeRunning = false
            } else if current == 1 {
                breakTimer.invalidate()
                isBreakTimeRunning = false
            } else if current == 2 {
                longBreakTimer.invalidate()
                isLongBreakTimeRunning = false
            } else if current == 3 {
                breakTimer.invalidate()
                isBreakTimeRunning = false
            }
            
        }
        
    }
    
}
