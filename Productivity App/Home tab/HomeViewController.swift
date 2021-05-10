//
//  HomeViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logButton: UIButton!
    
    @IBOutlet weak var logView: UIView!
    
    @IBOutlet weak var leaderboardsButton: UIButton!
    
    @IBOutlet weak var leaderBoardsView: UIView!
    
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    @IBOutlet weak var levelProgress: UIProgressView!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var currentLevel: UILabel!
    
    @IBOutlet weak var nextLevel: UILabel!
    
    var progress = 0
    var total = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeButtonGood(leaderboardsButton, leaderBoardsView)
        makeButtonGood(userButton, userView)
        makeButtonGood(logButton, logView)
        
        userButton.layer.cornerRadius = 30
        userView.layer.cornerRadius = 30
             
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("HEELLLOOO")
        getData()
        getGoalData()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//
//        saveProgress()
//        saveLevels()
//    }
    
//    func saveProgress() {
//        let db = Firestore.firestore()
//
//        db.collection("Goals").document("Level Data").setData([
//            "progress" : levelProgress.progress,
//            "progressNumber" : progress,
//            "total" : total
//        ])
//    }
//
//    func saveLevels() {
//        let22 db = Firestore.firestore()
//        let level = Int(levelLabel.text!)
//
//        db.collection("Goals").document("Level Data").setData([
//            "level" : level ?? 1
//        ])
//    }
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("Goals").document("Level Data").getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? ["error" : "error"]
                
                let current = dataDescription["level"] as? Int
                let currentInt = dataDescription["level"] as? Int
                let next = "\(currentInt! + 1)"
                
                self.levelLabel.text = "\(current ?? 1)"
                self.currentLevel.text = "\(current ?? 1)"
                self.nextLevel.text = next
                
                print("level: \(current ?? 1)")
                
                self.levelProgress.progress = (dataDescription["progress"] as! NSNumber).floatValue
                
                self.progress = dataDescription["progressNumber"] as! Int
                self.total = dataDescription["total"] as! Int
            }
        }
    }
    
    func getGoalData() {
        
        let db = Firestore.firestore()
        
        db.collection("Goals").document("Goal Data").getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? ["error" : "error"]
                let points = dataDescription["points"] as! Int
                let completed = dataDescription["completedGoals"] as! Int
                
                self.pointsLabel.text = "\(points) Goal Points"
                self.completedLabel.text = "\(completed) goals"
                    
            }
        }
        
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
    
    @IBAction func logPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToCalendar", sender: self)
    }
    
}
