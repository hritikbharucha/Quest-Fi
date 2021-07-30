//
//  CalendarViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit
import Firebase
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var goalsLabel: UILabel!
    
    @IBOutlet weak var bestLabel: UILabel!
    
    @IBOutlet weak var currentLabel: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
    
//    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCalendar()
        getGoals()
        
//        userID = Auth.auth().currentUser!.uid
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getGoals()
    }
    
    func setUpCalendar() {
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = Date()
        calendar.allowsMultipleSelection = true
    }
    
    func getGoals() {
        let db = Firestore.firestore()
        let cell = Calendar.current
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    let best = dataDescription["best"] as? Int ?? 0
                    
                    let timeStamps = dataDescription["dates"] as! [Timestamp]
                    var dates : [Date] = []
                    
                    for i in 0...timeStamps.count-1 {
                        let date = timeStamps[i].dateValue()
                        let timeZone = TimeZone.current.secondsFromGMT() / 3600
                        let rightDate = cell.date(byAdding: .hour, value: timeZone, to: date)
                        dates.append(rightDate ?? Date())
                    }
                    
                    var sortedDates = dates.sorted(by: { $0.compare($1) == .orderedAscending })
                    print("sorted dates: \(sortedDates)")
                    self.setStreaks(self.getStreaks(sortedDates), best)
                    print("STREAKS ARE: \(self.getStreaks(sortedDates) )")
                    
                    let today = Date()
                    let month = today.get(.month)
                    var goalsThisMonth = 0
                    self.calendar.allowsSelection = true
                    
                    for i in 0...sortedDates.count - 1 {
                        self.calendar.select(sortedDates[i])
                        print(sortedDates[i])
                        if sortedDates[i].get(.month) == month {
                            goalsThisMonth += 1
                        }
                    }
                    
                    self.goalsLabel.text = "\(goalsThisMonth) goals completed this month"
                    self.calendar.allowsSelection = false
                }
            }
        }
        
        
    }
    
    func setBest(_ best: Int) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Data").updateData([
                "best" : best
            ])
        }
        
        
    }
    
    func setStreaks(_ streak: Int, _ best: Int) {
        
        currentLabel.text = "\(streak)"
        
        print("STREEEEAAAAKKKSSS: \(streak)")
        print("BEEESSTTTT: \(best)")
        
        if streak > best {
            bestLabel.text = "\(streak)"
            print("New BEST: \(streak)")
            setBest(streak)
        } else {
            bestLabel.text = "\(best)"
        }
    }
    
    func getStreaks(_ dates: [Date]) -> Int {
        let calen = Calendar.current
        var streak = 0
        
        if dates.count > 1 {
            if calen.startOfDay(for: Date()) == calen.startOfDay(for: dates.last ?? Date()) {
                streak += 1
                print("ADDED TODAY ALSO: \(dates.last)")
                for i in stride(from: dates.count-1, to: 1, by: -1) {
                    
                    let previousDay = calen.date(byAdding: .day, value: -1, to: dates[i])
                    print("PREVIOUS DAY: \(String(describing: previousDay))")
                    
                    let prev = calen.startOfDay(for: previousDay ?? Date())
                    print("prev: \(prev)")
                    let actualPrev = calen.startOfDay(for: dates[i-1])
                    print("actual prev: \(actualPrev)")
                    
                    if prev == actualPrev {
                        streak += 1
                    } 
                }
            }
        }
        
        return streak
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        view.layoutIfNeeded()
    }
    
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
