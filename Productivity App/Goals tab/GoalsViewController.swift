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
    
    open var goalsCount = -1
    
    open var index = -1
    
    open var textDict = [Int : String]()
    
    open var colorDict = [Int : UIColor]()
    
    open var typeDict = [Int : String]()
    
    open var totalDict = [Int : String]()
    
    static var taskNameArray = [""]
    
    static var completedNameArray = [""]
    
    static var goalPoints = 0
    
    let db = Firestore.firestore()
    var addingForProgressive = false
    var addingForLongProgressive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            print("reloading")
            self.goalsCount += 1
            self.index += 1
            
            print("Goal count in dispatch: \(self.goalsCount)")
            
            if (self.goalsCount >= 1) {
                self.saveTaskNames()
                self.saveCompletedNames()
            }
            
            self.makeTaskNameArray {
                self.toDoTableView.reloadData()
            }
            
            self.makeCompletedNameArray {
                self.completedTableView.reloadData()
            }
            
        }
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
            print("add")
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
        
        print("Start height: \(startHeight)")
        print("Calc height: \(calcHeight)")

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
        db.collection("Goals").document("Goal Names").setData([
            
            "tasks" : Self.taskNameArray
            
        ])
    }
    
    func makeTaskNameArray(completion: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("Goals").document("Goal Names")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? ["error" : "error"]
                print("CHICKENDUCK: \(dataDescription)")
                
                Self.taskNameArray = (dataDescription["tasks"] as! [String])
                
            } else {
                print("Document does not exist")
            }
            
            completion()
        }
        
    }
    
    func saveCompletedNames() {
        let db = Firestore.firestore()
        db.collection("Goals").document("Completed Goal Names").setData([
            
            "tasks" : Self.completedNameArray
            
        ])
    }
    
    func makeCompletedNameArray(completion: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("Goals").document("Completed Goal Names")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? ["error" : "error"]
                print("CHICKENDUCK: \(dataDescription)")
                
                Self.completedNameArray = (dataDescription["tasks"] as! [String])
                
            } else {
                print("Document does not exist")
            }
            
            completion()
        }
        
    }
    
    @objc func progressPressed(_ button: UIButton) {
        let db = Firestore.firestore()
        
        print("PROGRESS HAS BEEN PRESSED ON GOAL \(button.tag)")
        
        let numArr = button.titleLabel?.text?.split(separator: "/")
        let startOptional = Int(numArr!.first ?? "0")
        let endOptional = Int(numArr!.last ?? "0")
        
        var start = startOptional ?? 0
        let end = endOptional ?? 0
        
        if start < end - 1 {
            start += 1
            button.setTitle("\(start)/\(end)", for: .normal)
            
            db.collection("Goals").document("Goal\(button.tag)").updateData([
                "progress": start
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
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
            Self.goalPoints += 2
            addingForProgressive = false
        } else if addingForLongProgressive {
            Self.goalPoints += 5
            addingForLongProgressive = false
        } else {
            Self.goalPoints += 1
        }
        
        db.collection("Goals").document("Goal Points").setData([
            
            "points" : Self.goalPoints
            
        ])
    }
    
    func createGoalPointsString() {
        let db = Firestore.firestore()
        
        db.collection("Goals").document("Goal Points").getDocument {
            (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? ["error" : "error"]
                let points = dataDescription["points"] as! Int
                
                Self.goalPoints = points
                self.deleteLabel.isHidden = false
                self.deleteLabel.text = "Goal Points: \(points)"
                
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
    
    @objc func completePressed(_ button: UIButton) {
        print("COMPLETE HAS BEEN PRESSED on goal \(button.tag)")
        
        addAndSaveGoalPoints()
        createGoalPointsString()
        
        if button.layer.borderWidth == 2 {
            print("PUTTING BLUE ON COMPLETE")
            button.backgroundColor = UIColor.systemBlue
            delayNoReturn(0.5) {
                button.backgroundColor = .clear
            }
        }
        
        let db = Firestore.firestore()
        
        db.collection("Goals").document("Goal\(button.tag)").getDocument {
            (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? ["error" : "error"]
                
                print("Setting data for Completed Goal\(Self.completedNameArray.count - 1)")
                db.collection("Goals").document("Completed Goal\(Self.completedNameArray.count - 1)").setData([
                    
                    "color" : dataDescription["color"],
                    "task" : dataDescription["task"],
                    "total" : dataDescription["total"],
                    "type" : dataDescription["type"]
                    
                ])
                
                Self.completedNameArray.append(dataDescription["task"] as! String)
                self.completedTableView.reloadData()
                
            } else {
                print("Document does not exist")
            }
        }

        delayNoReturn(0.3) {
            print("start: \(button.tag + 1)")
            print("end: \(Self.taskNameArray.count - 2)")

            db.collection("Goals").document("Goal\(button.tag)").delete()

            db.collection("Goals").document("Goals Index").getDocument {
                document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]

                    db.collection("Goals").document("Goals Index").setData ([

                        "index" : dataDescription["index"] as! Int - 1

                    ])
                } else {
                    print("Document does not exist")
                }
            }

            if (button.tag + 1 <= Self.taskNameArray.count - 2) {
                for i in button.tag...Self.taskNameArray.count - 2 {

                    self.delayNoReturn(Double(i)/20) {
                        db.collection("Goals").document("Goal\(i)").getDocument {
                            (document, error) in
                            if let document = document, document.exists {
                                let dataDescription = document.data() ?? ["error" : "error"]

                                print("Setting data for Goal\(i-1)")
                                db.collection("Goals").document("Goal\(i-1)").setData([

                                    "color" : dataDescription["color"],
                                    "index" : dataDescription["index"] as! Int - 1,
                                    "task" : dataDescription["task"],
                                    "total" : dataDescription["total"],
                                    "type" : dataDescription["type"]

                                ])

                                if (i != Self.taskNameArray.count - 2) {
                                    db.collection("Goals").document("Goal\(i)").delete()
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

    extension GoalsViewController: UITableViewDataSource, UITableViewDelegate {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView.tag == 2 {
                print("NUMBER OF ROWS FOR COMPLETE \(Self.completedNameArray.count - 1)")
                return Self.completedNameArray.count - 1
            }
            print("NUMBER OF ROWS FOR TASKS \(Self.taskNameArray.count - 1)")
            return Self.taskNameArray.count - 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("Goal count in create cell func: \(goalsCount)")
            print("creating cell")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Goal
            
            let db = Firestore.firestore()
            
            if tableView.tag == 2 {
                
                print("this is index row thing: Goal\(indexPath.row)")
                
                db.collection("Goals").document("Completed Goal\(indexPath.row)").getDocument {
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
            
            print("this is index row thing: Goal\(indexPath.row)")
            
            db.collection("Goals").document("Goal\(indexPath.row)").getDocument {
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
                    
                    print("DELAYED RETURN OF LABEL WIDTH IS \(cell.textLabel?.frame.width)")
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
                    
                    print("The width of row \(indexPath.row) is \(cell.textLabel?.frame.width)")
                    
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

            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if tableView.tag == 1 {
                    
                let db = Firestore.firestore()
                db
                
    //            print("row in select row thing: \(indexPath.row)")
    //
    //            print("start: \(indexPath.row + 1)")
    //            print("end: \(Self.taskNameArray.count - 2)")
                
                db.collection("Goals").document("Goal\(indexPath.row)").delete()

                db.collection("Goals").document("Goals Index").getDocument {
                    document, error in
                    if let document = document, document.exists {
                        let dataDescription = document.data() ?? ["error" : "error"]

                        db.collection("Goals").document("Goals Index").setData ([

                            "index" : dataDescription["index"] as! Int - 1

                        ])
                    } else {
                        print("Document does not exist")
                    }
                }
            

                if (indexPath.row + 1 <= Self.taskNameArray.count - 2) {
                    for i in indexPath.row + 1...Self.taskNameArray.count - 2 {

                        delayNoReturn(Double(i)/20) {
                            db.collection("Goals").document("Goal\(i)").getDocument {
                                (document, error) in
                                if let document = document, document.exists {
                                    let dataDescription = document.data() ?? ["error" : "error"]

                                    print("Setting data for Goal\(i-1)")
                                    db.collection("Goals").document("Goal\(i-1)").setData([
                                        
                                        "color" : dataDescription["color"],
                                        "index" : dataDescription["index"] as! Int - 1,
                                        "task" : dataDescription["task"],
                                        "total" : dataDescription["total"],
                                        "type" : dataDescription["type"]

                                    ])

                                    if (i != Self.taskNameArray.count - 2) {
                                        db.collection("Goals").document("Goal\(i)").delete()
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
