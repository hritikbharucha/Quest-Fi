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
    
//    @IBOutlet weak var leaderboardsButton: UIButton!
    
//    @IBOutlet weak var leaderboardsView: UIView!
    
//    @IBOutlet weak var goalsLabel: UILabel!
    
    @IBOutlet weak var bestLabel: UILabel!
    
    @IBOutlet weak var currentLabel: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var currentView: UIView!
    
    @IBOutlet weak var bestView: UIView!
    
    @IBOutlet weak var goalsView: UIView!
    
    @IBOutlet weak var pointsView: UIView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    var viewWidth : CGFloat = 414
    var viewHeight : CGFloat = 896
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getGoals()
        getGoalData()
        setUpCalendar()
        
        customize(currentView)
        customize(bestView)
        customize(goalsView)
        customize(pointsView)
        
//        createGradientAndRound(currentView, UIColor(red: 161, green: 88, blue: 255, alpha: 1).cgColor, UIColor(red: 205, green: 128, blue: 255, alpha: 1).cgColor)
//        createGradientAndRound(bestView, UIColor.systemTeal.cgColor, UIColor.blue.cgColor)
//        createGradientAndRound(goalsView, UIColor.blue.cgColor, UIColor.systemTeal.cgColor)
//        createGradientAndRound(pointsView, UIColor(red: 54, green: 148, blue: 155, alpha: 1).cgColor, UIColor(red: 28, green: 67, blue: 72, alpha: 1).cgColor)
    }
    
    func customize(_ view: UIView) {
        view.layer.cornerRadius = (10/896)*viewHeight
    }
    
//    func createGradientAndRound(_ view: UIView,_ firstColor: CGColor,_ secondColor: CGColor) {
//        let gradient = CAGradientLayer()
//
//        gradient.frame = view.bounds
//        gradient.colors = [firstColor, secondColor]
//
//        view.layer.insertSublayer(gradient, at: 0)
//        view.layer.cornerRadius = 10
//    }
    
    func getGoalData() {
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    let points = dataDescription["points"] as! Int
                    let completed = dataDescription["completedGoals"] as! Int
                    self.pointsLabel.text = "\(points)"
                    let completedText = "\(completed) goals"
                    
                    self.setSizes(self.completedLabel, completedText)
                }
            }
        }
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
                    
                    let sortedDates = dates.sorted(by: { $0.compare($1) == .orderedAscending })
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
                    
//                    self.goalsLabel.text = "\(goalsThisMonth) goals completed this month"
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
        
        let currentText = "\(streak) days"
        var bestText = ""
        
        print("STREEEEAAAAKKKSSS: \(streak)")
        print("BEEESSTTTT: \(best)")
        
        if streak > best {
            bestText = "\(streak) days"
            print("New BEST: \(streak)")
            setBest(streak)
        } else {
            bestText = "\(best) days"
        }
        
        setSizes(currentLabel, currentText)
        setSizes(bestLabel, bestText)
    }
    
    func setSizes(_ label: UILabel,_ string: String) {
        let attributedString = string.attributedString(letterSize: (25.0/896)*viewHeight, digitSize: (35.0/896)*viewHeight)
        
        label.attributedText = attributedString
    }
    
    func getStreaks(_ dates: [Date]) -> Int {
        let calen = Calendar.current
        var streak = 0
        
        print("date count \(dates.count)")
        
        if dates.count > 1 {
            if calen.startOfDay(for: Date()) == calen.startOfDay(for: dates.last ?? Date()) {
                streak += 1
                print("ADDED TODAY ALSO: \(String(describing: dates.last))")
                for i in stride(from: dates.count-1, to: 0, by: -1) {
                    
                    let previousDay = calen.date(byAdding: .day, value: -1, to: dates[i])
                    print("PREVIOUS DAY: \(String(describing: previousDay))")
                    
                    let prev = calen.startOfDay(for: previousDay ?? Date())
                    print("prev: \(prev)")
                    let actualPrev = calen.startOfDay(for: dates[i-1])
                    print("actual prev: \(actualPrev)")
                    
                    if prev == actualPrev {
                        streak += 1
                    }
                    
                    if prev > actualPrev {
                        return streak
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

extension String {

    func attributedString(letterSize: CGFloat, digitSize: CGFloat) -> NSAttributedString
    {
        let pattern = "\\d+"
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
        let attributedString = NSMutableAttributedString(string: self, attributes: [.font : UIFont.systemFont(ofSize: letterSize)])
        matches.forEach { attributedString.addAttributes([.font : UIFont.systemFont(ofSize: digitSize)], range: $0.range) }
        return attributedString.copy() as! NSAttributedString
    }
}
