//
//  GoalsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase

class GoalsViewController: UIViewController {
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    @IBOutlet weak var completedTableView: UITableView!
    
    @IBOutlet weak var todayTableView: UITableView!
    
    @IBOutlet weak var unscheduledTableView: UITableView!
    
    @IBOutlet weak var deleteLabel: UILabel!
    
    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var doneView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    open var textDict = [Int : String]()
    
    open var colorDict = [Int : UIColor]()
    
    open var typeDict = [Int : String]()
    
    open var totalDict = [Int : String]()
    
    @IBOutlet weak var tabsView: UICollectionView!
    
    static var taskNameArray = [[String : String]]()
    
    static var todayNameArray = [[String : String]]()
    
    static var unscheduledNameArray = [[String : String]]()
    
    static var completedNameArray = [[String : String]]()
    
    static var dailyNameArray = [[String : String]]()
    
    static var weeklyNameArray = [[String : String]]()
    
    @IBOutlet var completedTableViewHeight: NSLayoutConstraint!
    
    var readyToSave = false
    
    var visibleTableView = 0
    
    var completedGoalDates : [Date] = []
    var goalPoints = 0
    var goalsCompleted = 0
    
    var dayComponent = DateComponents()
    let calendar = Calendar.current
    
    var loadingAnimation = UIActivityIndicatorView()
    
    let db = Firestore.firestore()
//    var addingForProgressive = false
//    var addingForLongProgressive = false
    
    let reuseIdentifier = "cell"
    var items = ["Today", "Unscheduled", "All"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Self.taskNameArray = [[String : String]]()
        Self.todayNameArray = [[String : String]]()
        Self.unscheduledNameArray = [[String : String]]()
        Self.completedNameArray = [[String : String]]()
        Self.dailyNameArray = [[String : String]]()
        Self.weeklyNameArray = [[String : String]]()
        
        readyToSave = false
        
        completedTableViewHeight.constant = (193/896)*view.frame.height
        
        self.loadingAnimation.center = view.center
        self.loadingAnimation.style = .large
        
        dayComponent.day = 1
        
        setUpTableViews(toDoTableView, 1)
        setUpTableViews(completedTableView, 2)
        setUpTableViews(todayTableView, 3)
        setUpTableViews(unscheduledTableView, 4)
        
        tabsView.dataSource = self
        tabsView.delegate = self
        
        toDoTableView.register(UINib(nibName: "Goal", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        todayTableView.register(UINib(nibName: "Goal", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        unscheduledTableView.register(UINib(nibName: "Goal", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        completedTableView.register(UINib(nibName: "Goal", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tabsView.register(UINib(nibName: "TabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        doneView.isHidden = true
        doneButton.isHidden = true
        deleteLabel.isHidden = true
        
        getGoalData()
        createGoalPointsString()
        
        self.makeTaskNameArray {
            self.toDoTableView.reloadData()
            
            self.addRepeatedTasks {
                self.readyToSave = false
                self.toDoTableView.reloadData()
                self.completedTableView.reloadData()
                self.makeTodayNameArray {
                    self.loadingAnimation.stopAnimating()
                    self.todayTableView.reloadData()
                    print("today array \(Self.todayNameArray)")
                    self.readyToSave = true
                }
                
                self.makeUnscheduledArray {
                    self.unscheduledTableView.reloadData()
                    print("unscheduled array \(Self.unscheduledNameArray)")
                }
            }
        }
        
        self.makeCompletedNameArray {
            self.completedTableView.reloadData()
//            self.saveCompletedNames()
            self.removeYesterdayCompletedTasks {
                self.completedTableView.reloadData()
//                self.saveCompletedNames()
            }
        }
        
        tabsView.reloadData()
        tabsView.performBatchUpdates(nil, completion: {
            (result) in
            // ready
            self.tabsView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredVertically)
            self.collectionView(self.tabsView, didSelectItemAt: NSIndexPath(item: 0, section: 0) as IndexPath)
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        makeButtonGood(addButton, addView)
        makeButtonGood(doneButton, doneView)
        makeButtonGood(selectButton, selectView)
    }
    
    func setUpTableViews(_ tableView: UITableView, _ tag: Int) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = tag
        tableView.rowHeight = (100/896)*view.frame.height
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        readyToSave = false
        
        self.toDoTableView.reloadData()
        self.completedTableView.reloadData()
        self.todayTableView.reloadData()
        self.unscheduledTableView.reloadData()
        
        createGoalPointsString()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if readyToSave {
            self.saveTaskNames()
            self.saveCompletedNames()
            self.saveRepeatedTasks()
        }
    }
    
    func addRepeatedTasks(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let completionGroup = DispatchGroup()
        
        print("checking for repeat")
        loadDailyTasks { dailyNames in
            print("DAILY NAMES \(dailyNames)")
            for i in 0..<dailyNames.count {
                print("looping daily")
                completionGroup.enter()
                if let userID = Auth.auth().currentUser?.uid {
                    db.collection("\(userID)").document("\(dailyNames[i]["code"] ?? "NO CODE")").getDocument { document, error in
                        if let document = document, document.exists {
                            let dataDescription = document.data() ?? ["error" : "error"]
                            print("IN THE DOC")
                            if let lastActivatedTime = dataDescription["lastDate"] as? Timestamp {
                                print("last day \(lastActivatedTime)")
                                self.dayComponent.day = 1
                                let dayAfterLastActivation = self.calendar.date(byAdding: self.dayComponent, to: lastActivatedTime.dateValue())
//                                print("day after \(dayAfterLastActivation ?? Date())")
                                if Date() >= dayAfterLastActivation! {
                                    var contains = false
                                    for j in 0..<Self.taskNameArray.count {
                                        print("checking if exists already in tasks")
                                        if Self.taskNameArray[j]["code"] == dailyNames[i]["code"] {
                                            contains = true
                                            break
                                        }
                                    }
                                    for k in 0..<Self.completedNameArray.count {
                                        print("removing from completed array")
                                        if Self.completedNameArray[k]["code"] == dailyNames[i]["code"] {
                                            Self.completedNameArray.remove(at: k)
                                            break
                                        }
                                    }
                                    print("adding to task names")
                                    
                                    if !contains {
                                        Self.taskNameArray.append(["name" : dailyNames[i]["name"]!, "code" : dailyNames[i]["code"]!])
                                    }
                                    
                                    self.changeLastDateDaily(i)
                                }
                            }
                        } else {
                            print("Document of daily repeating task last date does not exist")
                        }
                        completionGroup.leave()
                    }
//                    print("tasks \(Self.taskNameArray)")
//                    for i in 0..<Self.taskNameArray.count {
//                        print("daily names code is \(dailyNames[h]["code"]) while the task code is \(Self.taskNameArray[i]["code"])")
//                        if dailyNames[h]["code"] == Self.taskNameArray[i]["code"] {
//                            db.collection("\(userID)").document("\(Self.taskNameArray[i]["code"] ?? "NO CODE")").getDocument { document, error in
//                                if let document = document, document.exists {
//                                    let dataDescription = document.data() ?? ["error" : "error"]
//                                    print("IN THE DOC")
//                                    if let lastActivatedTime = dataDescription["lastDate"] as? Timestamp {
//                                        print("last day \(lastActivatedTime)")
//                                        self.dayComponent.day = 1
//                                        let dayAfterLastActivation = self.calendar.date(byAdding: self.dayComponent, to: lastActivatedTime.dateValue())
//                                        print("day after \(dayAfterLastActivation)")
//                                        if Date() >= dayAfterLastActivation! {
//                                            var contains = false
//                                            for j in 0..<Self.taskNameArray.count {
//                                                print("checking if exists already in tasks")
//                                                if Self.taskNameArray[j]["code"] == dailyNames[h]["code"] {
//                                                    contains = true
//                                                    break
//                                                }
//                                            }
//                                            for k in 0..<Self.completedNameArray.count {
//                                                print("removing from completed array")
//                                                if Self.completedNameArray[k]["code"] == dailyNames[h]["code"] {
//                                                    Self.completedNameArray.remove(at: k)
//                                                    break
//                                                }
//                                            }
//                                            print("adding to task names")
//
//                                            if !contains {
//                                                Self.taskNameArray.append(["name" : dailyNames[h]["name"]!, "code" : dailyNames[h]["code"]!])
//                                            }
//
//                                            self.changeLastDateDaily(h)
//                                        }
//                                    }
//                                } else {
//                                    print("Document of daily repeating task last date does not exist")
//                                }
//                                completionGroup.leave()
//                            }
//                        }
//                    }
                }
            }
            completionGroup.notify(queue: DispatchQueue.main) {
                print("DONE")
                completion()
            }
        }
        loadWeeklyTasks { weeklyNames in
            print("WEEKLY NAMES \(weeklyNames)")
            for i in 0..<weeklyNames.count {
                print("looping weekly")
                completionGroup.enter()
                if let userID = Auth.auth().currentUser?.uid {
                    db.collection("\(userID)").document("\(weeklyNames[i]["code"] ?? "NO CODE")").getDocument { document, error in
                        if let document = document, document.exists {
                            let dataDescription = document.data() ?? ["error" : "error"]
                            print("IN THE DOC")
                            if let lastActivatedTime = dataDescription["lastDate"] as? Timestamp {
                                print("last day \(lastActivatedTime)")
                                self.dayComponent.day = 7
                                let dayAfterLastActivation = self.calendar.date(byAdding: self.dayComponent, to: lastActivatedTime.dateValue())
//                                print("week after \(dayAfterLastActivation)")
                                if Date() >= dayAfterLastActivation! {
                                    var contains = false
                                    for j in 0..<Self.taskNameArray.count {
                                        print("checking if exists already in tasks")
                                        if Self.taskNameArray[j]["code"] == weeklyNames[i]["code"] {
                                            contains = true
                                            break
                                        }
                                    }
                                    for k in 0..<Self.completedNameArray.count {
                                        print("removing from completed array")
                                        if Self.completedNameArray[k]["code"] == weeklyNames[i]["code"] {
                                            Self.completedNameArray.remove(at: k)
                                            break
                                        }
                                    }
                                    print("adding to task names")
                                    
                                    if !contains {
                                        Self.taskNameArray.append(["name" : weeklyNames[i]["name"]!, "code" : weeklyNames[i]["code"]!])
                                    }
                                    
                                    self.changeLastDateWeekly(i)
                                }
                            }
                        } else {
                            print("Document of weekly repeating task last date does not exist")
                        }
                        completionGroup.leave()
                    }
                }
            }
            completionGroup.notify(queue: DispatchQueue.main) {
                print("DONE")
                completion()
            }
        }
    }
    
    func changeLastDateDaily(_ index: Int) {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("\(Self.dailyNameArray[index]["code"] ?? "NO CODE")").setData(["lastDate" : Date(), "dateAndTime" : Date()], mergeFields: ["lastDate", "dateAndTime"])
        }
        
    }
    
    func changeLastDateWeekly(_ index: Int) {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("\(Self.weeklyNameArray[index]["code"] ?? "NO CODE")").setData(["lastDate" : Date(), "dateAndTime" : Date()], mergeFields: ["lastDate", "dateAndTime"])
        }
        
    }
    
    func removeLastDateDaily(_ index: Int) {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("\(Self.dailyNameArray[index]["code"] ?? "NO CODE")").updateData(["lastDate" : FieldValue.delete()])
        }
        
    }
    
    func removeLastDateWeekly(_ index: Int) {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("\(Self.weeklyNameArray[index]["code"] ?? "NO CODE")").updateData(["lastDate" : FieldValue.delete()])
        }
        
    }
    
    func saveRepeatedTasks() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Daily Names").setData([
                "dailyNames" : Self.dailyNameArray
            ])
            db.collection("\(userID)").document("Weekly Names").setData([
                "weeklyNames" : Self.weeklyNameArray
            ])
        }
    }
    
    func loadDailyTasks(completion: @escaping ([[String : String]]) -> Void) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Daily Names").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    Self.dailyNameArray = dataDesc["dailyNames"] as? [[String : String]] ?? [[String : String]]()
                    completion(Self.dailyNameArray)
                } else {
                    print("document of daily names does not exist")
                }
            }
//            completion()
        }
    }
    
    func loadWeeklyTasks(completion: @escaping ([[String : String]]) -> Void) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Weekly Names").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    Self.weeklyNameArray = dataDesc["weeklyNames"] as? [[String : String]] ?? [[String : String]]()
                    completion(Self.weeklyNameArray)
                } else {
                    print("document of weekly names does not exist")
                }
            }
        }
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = (2/414)*view.frame.width
        containerView.layer.cornerRadius = (15/414)*view.frame.width
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: (15/414)*view.frame.width).cgPath
        button.clipsToBounds = true
        button.layer.cornerRadius = (15/414)*view.frame.width
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        if sender.title(for: .normal) == "Add" {
            self.performSegue(withIdentifier: "goalsToAddGoals", sender: self)
        }
        
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        
        doneView.isHidden = false
        doneButton.isHidden = false
        
        deleteLabel.text = "Tap to delete"
        
        addView.isHidden = true
        addButton.isHidden = true
        
        selectView.isHidden = true
        selectButton.isHidden = true
        
        toDoTableView.allowsSelection = true
        todayTableView.allowsSelection = true
        unscheduledTableView.allowsSelection = true
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        
        doneView.isHidden = true
        doneButton.isHidden = true
        
        createGoalPointsString()
        
        addView.isHidden = false
        addButton.isHidden = false
        
        selectView.isHidden = false
        selectButton.isHidden = false
        
        toDoTableView.allowsSelection = false
        todayTableView.allowsSelection = false
        unscheduledTableView.allowsSelection = false
    }
    
    func delayNoReturn(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->(), _ num: Int) -> Int {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        return num
    }
    
    func adjustHeight(_ label: UILabel) {
        
        let startHeight = label.frame.size.height
        let calcHeight = label.sizeThatFits(label.frame.size).height  //iOS 8+ only
        
        if startHeight <= calcHeight {
            
            label.frame.size.height = calcHeight
            //            UIView.setAnimationsEnabled(false)  // Disable animations
            //            self.toDoTableView.beginUpdates()
            //            self.toDoTableView.endUpdates()
            //
            //            let scrollTo = self.toDoTableView.contentSize.height - self.toDoTableView.frame.size.height
            //            self.toDoTableView.setContentOffset(CGPoint(x: 0, y: scrollTo), animated: false)
            //
            //            UIView.setAnimationsEnabled(true)  // Re-enable animations.
        }
        
    }
    
    func saveTaskNames() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Names").setData([
                
                "tasks" : Self.taskNameArray
                
            ])
        }
        
    }
    
    func makeTaskNameArray(completion: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        
        self.loadingAnimation.hidesWhenStopped = true
        self.loadingAnimation.startAnimating()
        self.view.addSubview(self.loadingAnimation)
        
        print("LOADING NOW")
        
        if let userID = Auth.auth().currentUser?.uid {
            let docRef = db.collection("\(userID)").document("Goal Names")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    Self.taskNameArray = (dataDescription["tasks"] as! [[String : String]])
                    
                } else {
                    print("Document does not exist")
                    self.loadingAnimation.stopAnimating()
                    self.todayTableView.reloadData()
                    completion()
                }
                
                self.makeTodayNameArray {
                    self.todayTableView.reloadData()
                    print("today array \(Self.todayNameArray)")
                    self.readyToSave = true
                }
                
                self.makeUnscheduledArray {
                    self.unscheduledTableView.reloadData()
                    print("unscheduled array \(Self.unscheduledNameArray)")
                }
                
                completion()
            }
        } else {
            completion()
        }
        
    }
    
    func makeTodayNameArray(completion: @escaping() -> Void) {
        let completionGroup = DispatchGroup()
        let db = Firestore.firestore()
        var placeholderArray = [[String:String]]()
//        print("making today array")
        if let userID = Auth.auth().currentUser?.uid {
            for i in 0..<Self.taskNameArray.count {
                completionGroup.enter()
//                print("looping through tasks array")
                db.collection("\(userID)").document("\(Self.taskNameArray[i]["code"] ?? "NO CODE")").getDocument { document, error in
                    if let document = document, document.exists {
                        let dataDesc = document.data() ?? ["error" : "error"]
//                        print("\(i) index")
                        let scheduled = dataDesc["scheduled"] as! Bool
                        if scheduled {
                            let date = (dataDesc["dateAndTime"] as! Timestamp).dateValue()
//                            print("date of tasks is \(date.get(.day)) and today is \(Date().get(.day))")
                            if date.get(.day) == Date().get(.day) {
                                placeholderArray.append(["name" : Self.taskNameArray[i]["name"]!, "code" : Self.taskNameArray[i]["code"]!])
                            }
                        }
                    } else {
                        print("Doc does not exist")
                        completionGroup.leave()
                    }
                    completionGroup.leave()
                }
            }
            
            completionGroup.notify(queue: DispatchQueue.main, execute: {
//                print("now returning array \(Self.todayNameArray)")
                Self.todayNameArray = placeholderArray
                completion()
            })
            
//            delayNoReturn(Double(Self.taskNameArray.count)*0.1) {
//                print("now returning array after delay of \(Double(Self.taskNameArray.count)*0.1)")
//                completion()
//            }
        }
    }
    
    func makeUnscheduledArray(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let completionGroup = DispatchGroup()
        var placeholderArray = [[String:String]]()
        if let userID = Auth.auth().currentUser?.uid {
            for i in 0..<Self.taskNameArray.count {
                completionGroup.enter()
                db.collection("\(userID)").document("\(Self.taskNameArray[i]["code"] ?? "NO CODE")").getDocument { document, error in
                    if let document = document, document.exists {
                        let dataDesc = document.data() ?? ["error" : "error"]
                        
                        let scheduled = dataDesc["scheduled"] as! Bool
                        if !scheduled {
                            placeholderArray.append(["name" : Self.taskNameArray[i]["name"]!, "code" : Self.taskNameArray[i]["code"]!])
                        }
                    } else {
                        print("doc does not exist")
                        completionGroup.leave()
                    }
                    completionGroup.leave()
                }
            }
        }
        completionGroup.notify(queue: DispatchQueue.main) {
            Self.unscheduledNameArray = placeholderArray
            completion()
        }
    }
    
    func saveCompletedNames() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Completed Goal Names").setData([
                
                "tasks" : Self.completedNameArray
                
            ])
        }
        
    }
    
    func makeCompletedNameArray(completion: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            let docRef = db.collection("\(userID)").document("Completed Goal Names")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    Self.completedNameArray = (dataDescription["tasks"] as! [[String : String]])
                    
                } else {
                    print("Document does not exist")
                }
                
                completion()
            }
        }
        
    }
    
    func removeYesterdayCompletedTasks(completion: @escaping () -> Void) {
        
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "any-label-name")
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        
        dispatchQueue.async {
            if let userID = Auth.auth().currentUser?.uid {
                for i in stride(from: Self.completedNameArray.count-1, to: -1, by: -1) {
                    dispatchGroup.enter()
                    self.db.collection("\(userID)").document("\(Self.completedNameArray[i]["code"] ?? "NO CODE")").getDocument { document, error in
                        if let document = document, document.exists {
                            let dataDesc = document.data() ?? ["error" : "error"]
                            
                            let date = (dataDesc["dateAndTime"] as! Timestamp).dateValue()
//                            var dayComponent = DateComponents()
                            self.dayComponent.day = 1
                            let calendar = Calendar.current
                            let nextDate = calendar.date(byAdding: self.dayComponent, to: date)
                            
//                            print("next day of this task would be \(nextDate?.get(.day)) and today is currently \(Date().get(.day))")
                            
                            if nextDate!.get(.day) <= Date().get(.day) {
                                Self.completedNameArray.remove(at: i)
                                
//                                print("i is \(i)")
//                                print("array is \(Self.completedNameArray)")
                                
                                dispatchSemaphore.signal()
                                dispatchGroup.leave()
                            }
                        } else {
                            print("THE DOCUMENT OF THIS COMPLETED TASK CODE DOES NOT EXIST")
                            dispatchSemaphore.signal()
                            dispatchGroup.leave()
                        }
                        
                    }
                    dispatchSemaphore.wait()
                }
            }
        }
        
        dispatchGroup.notify(queue: dispatchQueue) {
            DispatchQueue.main.async {
                completion()
            }
        }
        
                
//        let resultArray = Self.completedNameArray.filter { newCompletedArray.contains($0) }
//        print("result array: \(resultArray)")
    }
    
//    @objc func progressPressed(_ button: UIButton) {
//        let db = Firestore.firestore()
//
//
//        let numArr = button.titleLabel?.text?.split(separator: "/")
//        let startOptional = Int(numArr!.first ?? "0")
//        let endOptional = Int(numArr!.last ?? "0")
//
//        var start = startOptional ?? 0
//        let end = endOptional ?? 0
//        
//        if start < end - 1 {
//            start += 1
//            button.setTitle("\(start)/\(end)", for: .normal)
//
//            if let userID = Auth.auth().currentUser?.uid {
//                db.collection("\(userID)").document("Goal\(button.tag)").updateData([
//                    "progress": start
//                ]) { err in
//                    if let err = err {
//                        print("Error updating document: \(err)")
//                    } else {
//                        print("Document successfully updated")
//                    }
//                }
//            }
//
//        } else {
//            button.isUserInteractionEnabled = false
//            start += 1
//            button.setTitle("\(start)/\(end)", for: .normal)
//
//            if end >= 5 && end < 10 {
//                addingForProgressive = true
//            } else if end >= 10 {
//                addingForLongProgressive = true
//            }
//
//            completePressed(button)
//        }
//    }
    
    func addAndSaveGoalPoints() {
        let db = Firestore.firestore()
        
//        if addingForProgressive {
//            goalPoints += 2
//            addingForProgressive = false
//        } else if addingForLongProgressive {
//            goalPoints += 5
//            addingForLongProgressive = false
//        } else {
//            goalPoints += 1
//        }
        
        goalPoints += 1
        goalsCompleted += 1
        
        let date = Date()
        completedGoalDates.append(date)
        
        if let userID = Auth.auth().currentUser?.uid {
            
            db.collection("\(userID)").document("Goal Data").getDocument { document, error in
                if let document = document, document.exists {
                    
                    db.collection("\(userID)").document("Goal Data").updateData([
                        
                        "points" : self.goalPoints,
                        "completedGoals" : self.goalsCompleted,
                        "dates" : self.completedGoalDates
                    ])
                    
                } else {
                    print("document does not exist")
                    
                    db.collection("\(userID)").document("Goal Data").setData([
                        
                        "points" : self.goalPoints,
                        "completedGoals" : self.goalsCompleted,
                        "dates" : self.completedGoalDates,
                        "best" : 0
                    ])
                    
                }
                
            }
            
        }
        
        delayNoReturn(1) {
            self.createGoalPointsString()
        }
        
        
    }
    
    func getGoalData() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Data").getDocument {
                (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    let points = dataDescription["points"] as! Int
                    let completed = dataDescription["completedGoals"] as! Int
                    let dates = dataDescription["dates"] as! [Timestamp]
                    
                    self.goalPoints = points
                    self.goalsCompleted = completed
                    print(dates)
                    for i in 0...dates.count-1 {
                        self.completedGoalDates.append(dates[i].dateValue())
                    }
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
        
    }
    
    func createGoalPointsString() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Data").getDocument {
                (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    let points = dataDescription["points"] as! Int
                    //                let completed = dataDescription["completedGoals"] as! Int
                    //                let dates = dataDescription["dates"] as? [Date] ?? [Date]()
                    //
                    //                self.goalPoints = points
                    //                self.goalsCompleted = completed
                    self.deleteLabel.isHidden = false
                    self.deleteLabel.text = "Goal Points: \(points)"
                    //                self.completedGoalDates = dates
                    
                    if points >= 10 {
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: (20/414)*self.view.frame.width)
                    } else if points >= 100 {
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: (15/414)*self.view.frame.width)
                    } else if points >= 1000 {
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: (10/414)*self.view.frame.width)
                    } else if points >= 10000 {
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: (5/414)*self.view.frame.width)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        
    }
    
    func levelUp() {
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Level Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    let progress = dataDescription["progressNumber"] as! Int + 1
                    let total = dataDescription["total"] as! Int
                    let level = dataDescription["level"] as! Int
                    
                    db.collection("\(userID)").document("User Data").getDocument { doc, err in
                        if let doc = doc, doc.exists {
                            let data = doc.data() ?? ["error" : "error"]
                            
                            let user = "User\(Int.random(in: 0...10000000))"
                            
                            let username = data["username"] as? String ?? user
                            
                            db.collection("Leaderboards").document(username).getDocument { docs, errs in
                                if let docs = docs, docs.exists {
                                    db.collection("Leaderboards").document(username).updateData([
                                        "level" : level,
                                        "name" : username
                                    ])
                                } else {
                                    db.collection("Leaderboards").document(username).setData([
                                        "level" : level,
                                        "name" : username
                                    ])
                                }
                            }
                            
                        }
                    }
                    
                    if Float(progress/total) >= 1 {
                        
                        db.collection("\(userID)").document("Level Data").updateData([
                            "progress" : 0,
                            "progressNumber" : 0,
                            "total" : Int(pow(Double(level), 1.5)),
                            "level" : level + 1
                        ])
                        
                        db.collection("\(userID)").document("User Data").getDocument { doc, err in
                            if let doc = doc, doc.exists {
                                let data = doc.data() ?? ["error" : "error"]
                                
                                let user = "User\(Int.random(in: 0...10000000))"
                                
                                let username = data["username"] as? String ?? user
                                
                                db.collection("Leaderboards").document(username).getDocument { docs, errs in
                                    if let docs = docs, docs.exists {
                                        db.collection("Leaderboards").document(username).updateData([
                                            "level" : level+1,
                                            "name" : username
                                        ])
                                    } else {
                                        db.collection("Leaderboards").document(username).setData([
                                            "level" : level+1,
                                            "name" : username
                                        ])
                                    }
                                }
                                
                            }
                        }
                    } else {
                        db.collection("\(userID)").document("Level Data").updateData([
                            "progress" : Float(progress)/Float(total),
                            "progressNumber" : progress
                        ])
                    }
                    
                } else {
                    db.collection("\(userID)").document("Level Data").setData([
                        "progress" : 0,
                        "progressNumber" : 0,
                        "total" : 2,
                        "level" : 2
                    ])
                    
                    db.collection("\(userID)").document("User Data").getDocument { doc, err in
                        if let doc = doc, doc.exists {
                            let data = doc.data() ?? ["error" : "error"]
                            
                            let user = "User\(Int.random(in: 0...10000000))"
                            
                            let username = data["username"] as? String ?? user
                            
                            db.collection("Leaderboards").document(username).getDocument { docs, errs in
                                if let docs = docs, docs.exists {
                                    db.collection("Leaderboards").document(username).updateData([
                                        "level" : 2,
                                        "name" : username
                                    ])
                                } else {
                                    db.collection("Leaderboards").document(username).setData([
                                        "level" : 2,
                                        "name" : username
                                    ])
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
//    func updateLastDate() {
//        let db = Firestore.firestore()
//
//        if let userID = Auth.auth().currentUser.uid {
//
//        }
//    }
    
    @objc func completePressed(_ button: UIButton) {
        
        print("BUTTON TAG IS \(button.tag)")
        
        addAndSaveGoalPoints()
        createGoalPointsString()
        levelUp()
//        updateLastDate()
        
        if visibleTableView == 0 {
            if button.layer.borderWidth == 2 {
                button.backgroundColor = UIColor.systemBlue
                delayNoReturn(0.5) {
                    button.backgroundColor = .clear
                }
            }
            
            Self.completedNameArray.append(["name" : Self.todayNameArray[button.tag]["name"]!, "code" : Self.todayNameArray[button.tag]["code"]!])
            
            self.completedTableView.reloadData()
            
            for i in 0..<Self.taskNameArray.count {
                if Self.taskNameArray[i]["code"] == Self.todayNameArray[button.tag]["code"] {
                    Self.taskNameArray.remove(at: i)
                    break
                }
            }
            
            Self.todayNameArray.remove(at: button.tag)
            
            self.saveTaskNames()
            
            self.delayNoReturn(0.3, closure: {
                self.toDoTableView.reloadData()
                self.todayTableView.reloadData()
            })
        } else if visibleTableView == 1 {
            if button.layer.borderWidth == 2 {
                button.backgroundColor = UIColor.systemBlue
                delayNoReturn(0.5) {
                    button.backgroundColor = .clear
                }
            }
            
            Self.completedNameArray.append(["name" : Self.unscheduledNameArray[button.tag]["name"]!, "code" : Self.unscheduledNameArray[button.tag]["code"]!])
            
            self.completedTableView.reloadData()
            
            for i in 0..<Self.taskNameArray.count {
                if Self.taskNameArray[i]["code"] == Self.unscheduledNameArray[button.tag]["code"] {
                    Self.taskNameArray.remove(at: i)
                    break
                }
            }
            
            Self.unscheduledNameArray.remove(at: button.tag)
            
            self.saveTaskNames()
            
            self.delayNoReturn(0.3, closure: {
                self.toDoTableView.reloadData()
                self.unscheduledTableView.reloadData()
            })
        } else if visibleTableView == 2 {
            if button.layer.borderWidth == 2 {
                button.backgroundColor = UIColor.systemBlue
                delayNoReturn(0.5) {
                    button.backgroundColor = .clear
                }
            }
            
            Self.completedNameArray.append(["name" : Self.taskNameArray[button.tag]["name"]!, "code" : Self.taskNameArray[button.tag]["code"]!])
            self.completedTableView.reloadData()
            
            for i in 0..<Self.unscheduledNameArray.count {
                if Self.unscheduledNameArray[i]["code"] == Self.taskNameArray[button.tag]["code"] {
                    Self.unscheduledNameArray.remove(at: i)
                    break
                }
            }
            
            for i in 0..<Self.todayNameArray.count {
                if Self.todayNameArray[i]["code"] == Self.taskNameArray[button.tag]["code"] {
                    Self.todayNameArray.remove(at: i)
                    break
                }
            }
            
            Self.taskNameArray.remove(at: button.tag)
            
            self.saveTaskNames()
            
            self.delayNoReturn(0.3, closure: {
                self.toDoTableView.reloadData()
                self.unscheduledTableView.reloadData()
                self.todayTableView.reloadData()
            })
        }
        
//        if button.layer.borderWidth == 2 {
//            button.backgroundColor = UIColor.systemBlue
//            delayNoReturn(0.5) {
//                button.backgroundColor = .clear
//            }
//        }
//
//        let db = Firestore.firestore()
//
//        Self.completedNameArray.append(["name" : Self.taskNameArray[button.tag]["name"]!, "code" : Self.taskNameArray[button.tag]["code"]!])
//        self.completedTableView.reloadData()
//
//        Self.taskNameArray.remove(at: button.tag)
//
//        self.saveTaskNames()
//
//        self.delayNoReturn(0.3, closure: {
//            self.toDoTableView.reloadData()
//        })
        
//        if let userID = Auth.auth().currentUser?.uid {
//            db.collection("\(userID)").document("Goal\(button.tag)").getDocument {
//                (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.data() ?? ["error" : "error"]
//
//                    db.collection("\(userID)").document("Completed Goal\(Self.completedNameArray.count - 1)").setData([
//
//                        "color" : dataDescription["color"] ?? "",
//                        "task" : dataDescription["task"] ?? "",
//                        "total" : dataDescription["total"] ?? ""
//                       "type" : dataDescription["type"] ?? ""
//
//                    ])
//
//                    Self.completedNameArray.append(dataDescription["task"] as! String)
//                    self.completedTableView.reloadData()
//
//                } else {
//                    print("Document does not exist")
//                }
//            }
//
//            delayNoReturn(0.3) {
//
//                db.collection("\(userID)").document("Goal\(button.tag)").delete()
//
//                db.collection("\(userID)").document("Goals Index").getDocument {
//                    document, error in
//                    if let document = document, document.exists {
//                        let dataDescription = document.data() ?? ["error" : "error"]
//
//                        db.collection("\(userID)").document("Goals Index").setData ([
//
//                            "index" : dataDescription["index"] as! Int - 1
//
//                        ])
//                    } else {
//                        print("Document does not exist")
//                    }
//                }
//
//                if (button.tag + 1 <= Self.taskNameArray.count - 2) {
//                    for i in button.tag...Self.taskNameArray.count - 2 {
//
//                        self.delayNoReturn(Double(i)/20) {
//                            db.collection("\(userID)").document("Goal\(i)").getDocument {
//                                (document, error) in
//                                if let document = document, document.exists {
//                                    let dataDescription = document.data() ?? ["error" : "error"]
//
//                                    db.collection("\(userID)").document("Goal\(i-1)").setData([
//
//                                        "color" : dataDescription["color"] ?? "",
//                                        "index" : dataDescription["index"] as! Int - 1,
//                                        "task" : dataDescription["task"] ?? "",
//                                        "total" : dataDescription["total"] ?? ""
//                                        "type" : dataDescription["type"] ?? ""
//
//                                    ])
//
//                                    if (i != Self.taskNameArray.count - 2) {
//                                        db.collection("\(userID)").document("Goal\(i)").delete()
//                                    }
//
//                                } else {
//                                    print("Document does not exist")
//                                }
//                            }
//                        }
//
//                    }
//                }
//
//                Self.taskNameArray.remove(at: button.tag + 1)
//                self.saveTaskNames()
//
//                self.delayNoReturn(0.3, closure: {
//                    self.toDoTableView.reloadData()
//                })
//            }
//        }
        
    }
    
    func checkDailyAndWeeklyArraysToRemove(_ index: Int, _ array: [[String:String]]) {
        for i in 0..<Self.dailyNameArray.count {
            if Self.dailyNameArray[i]["code"] == array[index]["code"] {
                removeLastDateDaily(i)
                Self.dailyNameArray.remove(at: i)
            }
        }
        for j in 0..<Self.weeklyNameArray.count {
            if Self.weeklyNameArray[j]["code"] == array[index]["code"] {
                removeLastDateWeekly(j)
                Self.weeklyNameArray.remove(at: j)
            }
        }
    }
    
    func checkDailyAndWeeklyArraysToChange(_ index: Int, _ array: [[String:String]]) {
        for i in 0..<Self.dailyNameArray.count {
            if Self.dailyNameArray[i]["code"] == array[index]["code"] {
                changeLastDateDaily(i)
            }
        }
        for j in 0..<Self.weeklyNameArray.count {
            if Self.weeklyNameArray[j]["code"] == array[index]["code"] {
                changeLastDateWeekly(j)
            }
        }
    }
    
}

extension GoalsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2 {
            return Self.completedNameArray.count
        } else if tableView.tag == 3 {
            return Self.todayNameArray.count
        } else if tableView.tag == 4 {
            return Self.unscheduledNameArray.count
        }
        return Self.taskNameArray.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Goal
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            
            if tableView.tag == 2 {
                
                let code = Self.completedNameArray[indexPath.row]["code"]
                
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
                        
                        let strikeThroughText = NSAttributedString(string: (dataDescription["task"] as! String), attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                        cell.taskLabel.attributedText = strikeThroughText
                        cell.taskLabel?.numberOfLines = 0
                        cell.taskLabel?.translatesAutoresizingMaskIntoConstraints = true
                        
                        let scheduled = dataDescription["scheduled"] as! Bool
                        
                        if scheduled {
                            let date = (dataDescription["dateAndTime"] as! Timestamp).dateValue()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "E, MMM d, yyyy h:mm a"
                            let dateString = dateFormatter.string(from: date)
                            
                            cell.dateTimeLabel?.text = dateString
                            cell.dateTimeLabel?.numberOfLines = 0
                            cell.dateTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
                            cell.dateTimeLabel?.lineBreakMode = .byWordWrapping
                        } else {
                            cell.dateTimeLabel.isHidden = true
                            cell.clockImage.isHidden = true
                        }
                        
                        cell.selectionStyle = .none
                        
                        cell.completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                        cell.completeButton.backgroundColor = .systemBlue
                        cell.completeButton.tintColor = .white
                        cell.completeButton.layer.borderWidth = 0
                        
//                        self.saveCompletedNames()
                        
                    } else {
                        print("Document does not exist")
                    }
                }
                
                return cell
                
            } else if tableView.tag == 3 {
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
                        
                        cell.completeButton.addTarget(self, action: #selector(self.completePressed), for: .touchUpInside)
                        cell.completeButton.tag = indexPath.row
                   
                    } else {
                        print("Document does not exist")
                    }
                }
                
                return cell
            } else if tableView.tag == 4 {
                let code = Self.unscheduledNameArray[indexPath.row]["code"]
                
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
                        
//                        cell.taskLabel?.topAnchor.constraint(equalTo: cell.goalContainerView.topAnchor, constant: 0).isActive = true
//                        cell.taskLabel?.bottomAnchor.constraint(equalTo: cell.dateTimeLabel.bottomAnchor, constant: -22).isActive = true
                        
                        cell.dateTimeLabel.isHidden = true
                        cell.clockImage.isHidden = true
                        
                        cell.completeButton.addTarget(self, action: #selector(self.completePressed), for: .touchUpInside)
                        cell.completeButton.tag = indexPath.row
                   
                    } else {
                        print("Document does not exist")
                    }
                }
                
                return cell
            }
            
            let code = Self.taskNameArray[indexPath.row]["code"]
            
            db.collection("\(userID)").document("\(code ?? "NO CODE FOUND")").getDocument {
                (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    self.textDict[indexPath.row] = (dataDescription["task"] as! String)
                    
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
//                    cell.taskLabel?.font = UIFont(name: "DIN Alternate", size: 30)
                    cell.taskLabel?.numberOfLines = 0
                    cell.taskLabel?.translatesAutoresizingMaskIntoConstraints = false
                    cell.taskLabel?.lineBreakMode = .byWordWrapping
                    
//                    cell.taskLabel?.leadingAnchor.constraint(equalTo: cell.goalContainerView.leadingAnchor, constant: 14).isActive = true
//                    cell.taskLabel?.trailingAnchor.constraint(equalTo: cell.goalContainerView.trailingAnchor, constant: -77).isActive = true
//                    cell.taskLabel?.topAnchor.constraint(equalTo: cell.goalContainerView.topAnchor, constant: 0).isActive = true
//                    cell.taskLabel?.widthAnchor.constraint(equalToConstant: 274).isActive = true
//                    cell.taskLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//                    cell.taskLabel?.bottomAnchor.constraint(equalTo: cell.dateTimeLabel.bottomAnchor, constant: -22).isActive = true
                    
                    let scheduled = dataDescription["scheduled"] as! Bool
                    
                    if scheduled {
                        let date = (dataDescription["dateAndTime"] as! Timestamp).dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "E, MMM d, yyyy"
                        let dateString = dateFormatter.string(from: date)
                        
                        cell.dateTimeLabel?.text = dateString
                        cell.dateTimeLabel?.numberOfLines = 0
                        cell.dateTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
                        cell.dateTimeLabel?.lineBreakMode = .byWordWrapping
                    } else {
                        cell.dateTimeLabel.isHidden = true
                        cell.clockImage.isHidden = true
                    }
                    
//                    cell.dateTimeLabel?.leadingAnchor.constraint(equalTo: cell.goalContainerView.leadingAnchor, constant: 42).isActive = true
//                    cell.dateTimeLabel?.trailingAnchor.constraint(equalTo: cell.goalContainerView.trailingAnchor, constant: -77).isActive = true
//                    cell.dateTimeLabel?.topAnchor.constraint(equalTo: cell.goalContainerView.topAnchor, constant: 0).isActive = true
//                    cell.dateTimeLabel?.widthAnchor.constraint(equalToConstant: 246).isActive = true
//                    cell.dateTimeLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
//                    cell.dateTimeLabel?.bottomAnchor.constraint(equalTo: cell.goalContainerView.bottomAnchor, constant: -8).isActive = true
                    
                    cell.completeButton.addTarget(self, action: #selector(self.completePressed), for: .touchUpInside)
                    cell.completeButton.tag = indexPath.row
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            
            checkDailyAndWeeklyArraysToRemove(indexPath.row, Self.taskNameArray)
            Self.taskNameArray.remove(at: indexPath.row)
            saveTaskNames()
            self.toDoTableView.reloadData()
            
        } else if tableView.tag == 3 {
            
            checkDailyAndWeeklyArraysToRemove(indexPath.row, Self.todayNameArray)
            
            for i in 0..<Self.taskNameArray.count {
                if Self.taskNameArray[i]["code"] == Self.todayNameArray[indexPath.row]["code"] {
                    Self.taskNameArray.remove(at: i)
                    break
                }
            }
            
            Self.todayNameArray.remove(at: indexPath.row)
            saveTaskNames()
            
            self.toDoTableView.reloadData()
            self.todayTableView.reloadData()
            
        } else if tableView.tag == 4 {
            
            checkDailyAndWeeklyArraysToRemove(indexPath.row, Self.unscheduledNameArray)
            
            for i in 0..<Self.taskNameArray.count {
                if Self.taskNameArray[i]["code"] == Self.unscheduledNameArray[indexPath.row]["code"] {
                    Self.taskNameArray.remove(at: i)
                    break
                }
            }
            
            Self.unscheduledNameArray.remove(at: indexPath.row)
            saveTaskNames()
            
            self.toDoTableView.reloadData()
            self.unscheduledTableView.reloadData()
            
        }
    }
}

extension GoalsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TabCollectionViewCell
        
        cell.tabLabel.text = self.items[indexPath.row]
        cell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        cell.layer.cornerRadius = (15/414)*view.frame.width
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabCollectionViewCell
        
        visibleTableView = indexPath.item
        
//        print("You selected cell #\(indexPath.item) with text \(cell.tabLabel.text)!")
        
        cell.contentView.backgroundColor = UIColor(red: 64/255, green: 144/255, blue: 245/255, alpha: 1)
        cell.tabLabel.textColor = .white
        
        if indexPath.item == 0 {
            self.todayTableView.isHidden = false
            self.toDoTableView.isHidden = true
            self.unscheduledTableView.isHidden = true
        } else if indexPath.item == 1 {
            self.todayTableView.isHidden = true
            self.toDoTableView.isHidden = true
            self.unscheduledTableView.isHidden = false
        } else if indexPath.item == 2 {
            self.todayTableView.isHidden = true
            self.toDoTableView.isHidden = false
            self.unscheduledTableView.isHidden = true
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabCollectionViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        cell.tabLabel.textColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (128/414)*view.frame.width, height: (42/813)*view.frame.height)
    }
}
