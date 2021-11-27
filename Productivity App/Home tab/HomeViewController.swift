//
//  HomeViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase
//import FSCalendar

class HomeViewController: UIViewController {
    
    @IBOutlet weak var leaderboardsButton: UIButton!

    @IBOutlet weak var leaderBoardsView: UIView!
    
    @IBOutlet weak var helloLabel: UILabel!
    
//    @IBOutlet weak var userView: UIView!
//
//    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var circularProgress: CircularProgress!
    
    @IBOutlet weak var todayTaskTableView: UITableView!
    
    @IBOutlet weak var seeAllBtn: UIButton!
    
    @IBOutlet weak var noActiveLabel: UILabel!
    
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var weekdayLabel: UILabel!
    
    static var todayNameArray = [[String : String]]()
    
    var viewWidth : CGFloat = 414
    var viewHeight : CGFloat = 896
    
    var progress = 0
    var total = 1
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width
        
        seeAllBtn.layer.cornerRadius = (10/896)*viewHeight
        
        noActiveLabel.layer.cornerRadius = (5/896)*viewHeight
        
        setUpTableViews(todayTaskTableView)
        
        getTodayGoal()
    }
    
    func setUpTableViews(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = (90/896)*viewHeight
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "Goal", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    func getName() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("User Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    let name = dataDescription["name"] as? String ?? ""
                    let first = name.components(separatedBy: " ").first
//                    print("\(name), \(first)")
                    
                    self.helloLabel.text = "Hello \(first ?? name),"
                        
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
//        gpLogo.layer.cornerRadius = gpLogo.frame.width/2
//        gpLogo.font = gpLogo.font.withSize(gpLogo.frame.width*2/3)
        
        weekdayLabel.roundedLabelTop()
        
        circularProgress.lineWidth = (12/414)*viewWidth
        
        makeButtonGood(leaderboardsButton, leaderBoardsView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getData()
        refreshTodayGoal()
//        getGoalData()
        getName()
        loadCalendar()
        
//        setUpCalendar()
    }
    
    func refreshTodayGoal() {
        Self.todayNameArray = GoalsViewController.todayNameArray
        todayTaskTableView.reloadData()
    }
    
    func getTodayGoal() {
        let db = Firestore.firestore()
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        Self.todayNameArray = [[String:String]]()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Names").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    let tasksArray = (dataDescription["tasks"] as? [[String:String]]) ?? [[String:String]]()
                    
                    print("tasks array is \(tasksArray)")
                    
                    if !tasksArray.isEmpty {
                        if let code = tasksArray[0]["code"], let name = tasksArray[0]["name"] {
                            db.collection("\(userID)").document("\(code)").getDocument { doc, err in
                                if let doc = doc, doc.exists {
                                    let dataDesc = doc.data() ?? ["error" : "error"]
                                    let scheduled = dataDesc["scheduled"] as! Bool
                                    if scheduled {
                                        let date = (dataDesc["dateAndTime"] as! Timestamp).dateValue()
                                        if date.get(.day) == Date().get(.day) {
                                            Self.todayNameArray.append(["name" : name, "code" : code])
                                            print("today array at this point \(Self.todayNameArray)")
                                            completionGroup.leave()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        completionGroup.notify(queue: DispatchQueue.main, execute: {
            // DIDNT LOAD TODAY NAME ARRAY WHYYYYYYYYYY
            
            print("loaded today: \(Self.todayNameArray)")
            self.todayTaskTableView.reloadData()
        })
    }
    
    func loadCalendar() {
        calendarButton.layer.cornerRadius = (10/896)*viewHeight
        calendarButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: Date())
        
        weekdayLabel.text = weekDay
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "d"
        let day = dateFormatter2.string(from: Date())
        
        calendarButton.setTitle(day, for: .normal)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//
//        saveProgress()
//        saveLevels()
//    }
    
    func getData() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection(userID).document("Level Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    let current = dataDescription["level"] as? Int
                    
                    self.levelLabel.text = "\(current ?? 1)"
                    
//                    print("level: \(current ?? 1)")
                    
                    self.circularProgress.strokeEnd = CGFloat((dataDescription["progress"] as! NSNumber).floatValue)
                    
                    self.progress = dataDescription["progressNumber"] as! Int
                    self.total = dataDescription["total"] as! Int
                }
            }
        }
        
        
    }
    
    @IBAction func calendarPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToCalendar", sender: self)
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = (4/896)*viewHeight
        containerView.layer.cornerRadius = (15/896)*viewHeight
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: (15/896)*viewHeight).cgPath
        button.clipsToBounds = true
        button.layer.cornerRadius = (15/896)*viewHeight
        
    }
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToProfile", sender: self)
    }
    
    @IBAction func logPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "homeToCalendar", sender: self)
    }
    
    @IBAction func leaderboardsPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToLeaderboards", sender: self)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Self.todayNameArray.isEmpty {
            noActiveLabel.isHidden = false
            todayTaskTableView.isHidden = true
            return 0
        } else {
            noActiveLabel.isHidden = true
            todayTaskTableView.isHidden = false
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Goal
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            let code = Self.todayNameArray[indexPath.row]["code"]
            print("Contents of today: \(Self.todayNameArray)")
            
            db.collection("\(userID)").document("\(code ?? "NO CODE FOUND")").getDocument {
                (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    if (dataDescription["color"] as! String == "gray") {
                        cell.goalContainerView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
                    } else if (dataDescription["color"] as! String == "purple") {
                        cell.goalContainerView.backgroundColor = UIColor(red: 178.0/255.0, green: 93.0/255.0, blue: 255.0/255.0, alpha: 0.85)
                    } else if (dataDescription["color"] as! String == "teal") {
                        cell.goalContainerView.backgroundColor = UIColor.systemTeal
                    } else if (dataDescription["color"] as! String == "red") {
                        cell.goalContainerView.backgroundColor = UIColor.systemRed
                    } else if (dataDescription["color"] as! String == "green") {
                        cell.goalContainerView.backgroundColor = UIColor.systemGreen
                    } else if (dataDescription["color"] as! String == "orange") {
                        cell.goalContainerView.backgroundColor = UIColor.systemOrange
                    }
                    
                    cell.taskLabel?.text = (dataDescription["task"] as! String)
                    cell.taskLabel?.numberOfLines = 0
                    cell.taskLabel?.translatesAutoresizingMaskIntoConstraints = false
                    cell.taskLabel?.lineBreakMode = .byWordWrapping
                    
                    let scheduled = dataDescription["scheduled"] as! Bool
                    
                    if scheduled {
                        let date = (dataDescription["dateAndTime"] as! Timestamp).dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        let dateString = dateFormatter.string(from: date)
                        
                        cell.dateTimeLabel?.text = dateString
                        cell.dateTimeLabel?.numberOfLines = 0
                        cell.dateTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
                        cell.dateTimeLabel?.lineBreakMode = .byWordWrapping
                    } else {
                        cell.dateTimeLabel.isHidden = true
                        cell.clockImage.isHidden = true
                    }
                    
                    cell.completeButton.isHidden = true
               
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        return cell
        
    }
    
}

extension UILabel{
    func roundedLabelTop(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
