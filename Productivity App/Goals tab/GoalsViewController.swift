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
    
    @IBOutlet weak var deleteLabel: UILabel!
    
    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var doneView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
//    var userID = ""
    
    open var goalsCount = -1
    
    open var index = -1
    
    open var textDict = [Int : String]()
    
    open var colorDict = [Int : UIColor]()
    
    open var typeDict = [Int : String]()
    
    open var totalDict = [Int : String]()
    
    static var taskNameArray = [""]
    
    static var completedNameArray = [""]
    
    var completedGoalDates : [Date] = []
    var goalPoints = 0
    var goalsCompleted = 0
    
    let db = Firestore.firestore()
    var addingForProgressive = false
    var addingForLongProgressive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userID = Auth.auth().currentUser!.uid
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        completedTableView.dataSource = self
        completedTableView.delegate = self
        
        toDoTableView.tag = 1
        completedTableView.tag = 2
        
        toDoTableView.estimatedRowHeight = 85.0
        toDoTableView.rowHeight = UITableView.automaticDimension
        
        toDoTableView.allowsSelection = false
        
        toDoTableView.register(UINib(nibName: "Goal", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        completedTableView.register(UINib(nibName: "Goal", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        makeButtonGood(addButton, addView)
        makeButtonGood(doneButton, doneView)
        makeButtonGood(selectButton, selectView)
        
        doneView.isHidden = true
        doneButton.isHidden = true
        deleteLabel.isHidden = true
        
        getGoalData()
        createGoalPointsString()
        
        self.makeTaskNameArray {
            self.toDoTableView.reloadData()
        }
        
        self.makeCompletedNameArray {
            self.completedTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
            self.goalsCount += 1
            self.index += 1
            
            
            if (self.goalsCount >= 1) {
                self.saveTaskNames()
                self.saveCompletedNames()
            }
            
            Self.taskNameArray = [""]
            self.makeTaskNameArray {
                self.toDoTableView.reloadData()
            }
            
            Self.completedNameArray = [""]
            self.makeCompletedNameArray {
                self.completedTableView.reloadData()
            }
            
        }
        
        createGoalPointsString()
//        index += 1
//        print("Goal Index in view will appear: \(index)")
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
        
        if let userID = Auth.auth().currentUser?.uid {
            let docRef = db.collection("\(userID)").document("Goal Names")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    Self.taskNameArray = (dataDescription["tasks"] as! [String])
                    
                } else {
                    print("Document does not exist")
                }
                
                completion()
            }
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
                    
                    Self.completedNameArray = (dataDescription["tasks"] as! [String])
                    
                } else {
                    print("Document does not exist")
                }
                
                completion()
            }
        }
        
    }
    
    @objc func progressPressed(_ button: UIButton) {
        let db = Firestore.firestore()
        
        
        let numArr = button.titleLabel?.text?.split(separator: "/")
        let startOptional = Int(numArr!.first ?? "0")
        let endOptional = Int(numArr!.last ?? "0")
        
        var start = startOptional ?? 0
        let end = endOptional ?? 0
        
        if start < end - 1 {
            start += 1
            button.setTitle("\(start)/\(end)", for: .normal)
            
            if let userID = Auth.auth().currentUser?.uid {
                db.collection("\(userID)").document("Goal\(button.tag)").updateData([
                    "progress": start
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            
        } else {
            start += 1
            button.setTitle("\(start)/\(end)", for: .normal)
            
            if end >= 5 && end < 10 {
                addingForProgressive = true
            } else if end >= 10 {
                addingForLongProgressive = true
            }
            
            completePressed(button)
        }
    }
    
    func addAndSaveGoalPoints() {
        let db = Firestore.firestore()
        
        if addingForProgressive {
            goalPoints += 2
            addingForProgressive = false
        } else if addingForLongProgressive {
            goalPoints += 5
            addingForLongProgressive = false
        } else {
            goalPoints += 1
        }
        
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
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: 20)
                    } else if points >= 100 {
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: 15)
                    } else if points >= 1000 {
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: 10)
                    } else if points >= 10000 {
                        self.deleteLabel.font = UIFont(name: "DIN Alternate", size: 5)
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
    
    @objc func completePressed(_ button: UIButton) {
        
        addAndSaveGoalPoints()
        createGoalPointsString()
        levelUp()
        
        if button.layer.borderWidth == 2 {
            button.backgroundColor = UIColor.systemBlue
            delayNoReturn(0.5) {
                button.backgroundColor = .clear
            }
        }
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal\(button.tag)").getDocument {
                (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    db.collection("\(userID)").document("Completed Goal\(Self.completedNameArray.count - 1)").setData([
                        
                        "color" : dataDescription["color"] ?? "",
                        "task" : dataDescription["task"] ?? "",
                        "total" : dataDescription["total"] ?? "",
                        "type" : dataDescription["type"] ?? ""
                        
                    ])
                    
                    Self.completedNameArray.append(dataDescription["task"] as! String)
                    self.completedTableView.reloadData()
                    
                } else {
                    print("Document does not exist")
                }
            }

            delayNoReturn(0.3) {

                db.collection("\(userID)").document("Goal\(button.tag)").delete()

                db.collection("\(userID)").document("Goals Index").getDocument {
                    document, error in
                    if let document = document, document.exists {
                        let dataDescription = document.data() ?? ["error" : "error"]

                        db.collection("\(userID)").document("Goals Index").setData ([

                            "index" : dataDescription["index"] as! Int - 1

                        ])
                    } else {
                        print("Document does not exist")
                    }
                }

                if (button.tag + 1 <= Self.taskNameArray.count - 2) {
                    for i in button.tag...Self.taskNameArray.count - 2 {

                        self.delayNoReturn(Double(i)/20) {
                            db.collection("\(userID)").document("Goal\(i)").getDocument {
                                (document, error) in
                                if let document = document, document.exists {
                                    let dataDescription = document.data() ?? ["error" : "error"]

                                    db.collection("\(userID)").document("Goal\(i-1)").setData([

                                        "color" : dataDescription["color"] ?? "",
                                        "index" : dataDescription["index"] as! Int - 1,
                                        "task" : dataDescription["task"] ?? "",
                                        "total" : dataDescription["total"] ?? "",
                                        "type" : dataDescription["type"] ?? ""

                                    ])

                                    if (i != Self.taskNameArray.count - 2) {
                                        db.collection("\(userID)").document("Goal\(i)").delete()
                                    }

                                } else {
                                    print("Document does not exist")
                                }
                            }
                        }

                    }
                }

                Self.taskNameArray.remove(at: button.tag + 1)
                self.saveTaskNames()

                self.delayNoReturn(0.3, closure: {
                    self.toDoTableView.reloadData()
                })
            }
        }
         
    }
    
}

    extension GoalsViewController: UITableViewDataSource, UITableViewDelegate {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView.tag == 2 {
                return Self.completedNameArray.count - 1
            }
            return Self.taskNameArray.count - 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Goal
            
            let db = Firestore.firestore()
            
            if let userID = Auth.auth().currentUser?.uid {
                if tableView.tag == 2 {
                                    
                    db.collection("\(userID)").document("Completed Goal\(indexPath.row)").getDocument {
                        (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data() ?? ["error" : "error"]
                            
                            if (dataDescription["color"] as! String == "purple") {
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
                            
                            cell.textLabel?.text = (dataDescription["task"] as! String)
                            cell.textLabel?.font = UIFont(name: "DIN Alternate", size: 30)
                            cell.textLabel?.numberOfLines = 0
                            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = true
                            
                            cell.selectionStyle = .none
                            
                            self.saveCompletedNames()
                            
                        } else {
                            print("Document does not exist")
                        }
                    }

                    return cell
                    
                }
                
                
                db.collection("\(userID)").document("Goal\(indexPath.row)").getDocument {
                    (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data() ?? ["error" : "error"]
                        
                        self.textDict[indexPath.row] = (dataDescription["task"] as! String)
                        
                        if (dataDescription["color"] as! String == "purple") {
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
                        
                        cell.textLabel?.text = (dataDescription["task"] as! String)
                        cell.textLabel?.font = UIFont(name: "DIN Alternate", size: 30)
                        cell.textLabel?.numberOfLines = 0
                        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
                        cell.textLabel?.lineBreakMode = .byWordWrapping
    //                    cell.textLabel?.sizeToFit()
                        
    //                    cell.textLabel?.adjustsFontSizeToFitWidth = true
    //                    cell.textLabel?.minimumScaleFactor = 0.5
                    
    //                    cell.textLabel?.adjustsFontForContentSizeCategory = true
                        
                        cell.textLabel?.leadingAnchor.constraint(equalTo: cell.goalContainerView.leadingAnchor, constant: 5).isActive = true
                        cell.textLabel?.trailingAnchor.constraint(equalTo: cell.goalContainerView.trailingAnchor, constant: -60).isActive = true
                        cell.textLabel?.topAnchor.constraint(equalTo: cell.goalContainerView.topAnchor, constant: 5).isActive = true
    //                    cell.textLabel?.bottomAnchor.constraint(greaterThanOrEqualTo: cell.goalContainerView.bottomAnchor, constant: -5).isActive = true
                        cell.textLabel?.widthAnchor.constraint(equalToConstant: 306).isActive = true
                        
                        cell.textLabel?.bottomAnchor.constraint(equalTo: cell.goalContainerView.bottomAnchor, constant: -5).isActive = true
    //                    cell.textLabel?.heightAnchor.constraint(greaterThanOrEqualTo: cell.goalContainerView.heightAnchor, constant: 0).isActive = true
                        
    //                    cell.textLabel?.adjustsFontSizeToFitWidth = true

                        cell.completeButton.addTarget(self, action: #selector(self.completePressed), for: .touchUpInside)
                        cell.progressButton.addTarget(self, action: #selector(self.progressPressed), for: .touchUpInside)
                        
                        
                        if (dataDescription["type"] as! String == "Progressive") {
                            print("\(String(describing: dataDescription["type"])) is a progressive cell")
                            cell.progressButton.isHidden = false
                            cell.completeButton.isHidden = true
                            cell.progressButton.setTitle("\(dataDescription["progress"] ?? "0")/\( dataDescription["total"] ?? "1")", for: .normal)
                            print("0/\( dataDescription["total"] ?? "1")")
                            cell.progressButton.tag = indexPath.row
                            
                            cell.progressButton.titleLabel?.adjustsFontSizeToFitWidth = true
                            cell.progressButton.titleLabel?.minimumScaleFactor = 0.5
                            cell.progressButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = true
                        } else if (dataDescription["type"] as! String == "One Time") {
                            print("\(String(describing: dataDescription["type"])) is a one time cell")
                            cell.progressButton.isHidden = true
                            cell.completeButton.isHidden = false
                            cell.completeButton.tag = indexPath.row
                        }
                        
    //                    self.delayNoReturn(3) {
    //                        print("DELAYED RETURN OF LABEL WIDTH IS \(cell.textLabel?.frame.width)")
    //                        cell.textLabel?.adjustsFontSizeToFitWidth = true
    //
    //                        print("ADJUSTING HEIGHT OF GOAL \(indexPath.row)")
    ////                        self.adjustHeight(cell.textLabel!)
    ////                        cell.textLabel?.sizeToFit()
    //                        cell.goalContainerView.frame.size.height = (cell.textLabel?.frame.height)!
    //                        cell.goalContainerView.layoutIfNeeded()
    //
    //                        self.delayNoReturn(3) {
    //                            cell.contentView.frame.size.height = cell.goalContainerView.frame.size.height
    //                            cell.contentView.layoutIfNeeded()
    //
    //                            UIView.setAnimationsEnabled(false)  // Disable animations
    //                            tableView.beginUpdates()
    //                            tableView.endUpdates()
    //
    //
    //                            let scrollTo = tableView.contentSize.height - tableView.frame.size.height
    //                            tableView.setContentOffset(CGPoint(x: 0, y: scrollTo), animated: false)
    //
    //                            UIView.setAnimationsEnabled(true)
    //                        }
    //
    //                    }
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if tableView.tag == 1 {
                    
                let db = Firestore.firestore()
                
                if let userID = Auth.auth().currentUser?.uid {
                    db.collection("\(userID)").document("Goal\(indexPath.row)").delete()

                    db.collection("\(userID)").document("Goals Index").getDocument {
                        document, error in
                        if let document = document, document.exists {
                            let dataDescription = document.data() ?? ["error" : "error"]

                            db.collection("\(userID)").document("Goals Index").setData ([

                                "index" : dataDescription["index"] as! Int - 1

                            ])
                        } else {
                            print("Document does not exist")
                        }
                    }
                

                    if (indexPath.row + 1 <= Self.taskNameArray.count - 2) {
                        for i in indexPath.row + 1...Self.taskNameArray.count - 2 {

                            delayNoReturn(Double(i)/20) {
                                db.collection("\(userID)").document("Goal\(i)").getDocument {
                                    (document, error) in
                                    if let document = document, document.exists {
                                        let dataDescription = document.data() ?? ["error" : "error"]

                                        db.collection("\(userID)").document("Goal\(i-1)").setData([
                                            
                                            "color" : dataDescription["color"] ?? "",
                                            "index" : dataDescription["index"] as! Int - 1,
                                            "task" : dataDescription["task"] ?? "",
                                            "total" : dataDescription["total"] ?? "",
                                            "type" : dataDescription["type"] ?? ""

                                        ])

                                        if (i != Self.taskNameArray.count - 2) {
                                            db.collection("\(userID)").document("Goal\(i)").delete()
                                        }
                                        
                                    } else {
                                        print("Document does not exist")
                                    }
                                }
                            }

                        }
                    }

                    Self.taskNameArray.remove(at: indexPath.row + 1)
                    saveTaskNames()

                    delayNoReturn(0.3, closure: {
                        self.toDoTableView.reloadData()
                    })
                }
                
                
            }
        }
    }
