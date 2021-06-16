//
//  AddGoalsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/23/21.
//

import UIKit
import Firebase

class AddGoalsViewController: UIViewController {
    
    @IBOutlet weak var progressiveButton: UIButton!
    
    @IBOutlet weak var progressiveView: UIView!
    
    @IBOutlet weak var oneTimeButton: UIButton!
    
    @IBOutlet weak var oneTimeView: UIView!
    
    @IBOutlet weak var totalTextField: UITextField!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var grayButton: UIButton!
    
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var orangeButton: UIButton!
    
    @IBOutlet weak var grayView: UIView!
    
    @IBOutlet weak var blueView: UIView!
    
    @IBOutlet weak var redView: UIView!
    
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var orangeView: UIView!
    
    @IBOutlet weak var taskTextView: UITextView!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
//    var userID = ""
    
    open var color = "UIColor.gray"
    
    open var text = ""
    
    open var total = ""
    
    open var type = "One Time"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
//        userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goals Index").getDocument { (document, error) in
                if let document = document, document.exists {
    //                let dataDescription = document.data() ?? ["error" : "error"]
                    print("Document does exist")
                } else {
                    db.collection("\(userID)").document("Goals Index").setData([
                        "index" : 0
                    ])
                }
            }
        }

        makeButtonGood(progressiveButton, progressiveView)
        makeButtonGood(oneTimeButton, oneTimeView)
        makeButtonGood(addButton, addView)
        
        makeSelectionButton(grayButton)
        makeSelectionButton(blueButton)
        makeSelectionButton(redButton)
        makeSelectionButton(greenButton)
        makeSelectionButton(orangeButton)
        
        taskTextView.layer.borderColor = UIColor.black.cgColor
        taskTextView.layer.borderWidth = 2
        
        totalTextField.isHidden = true
        totalLabel.isHidden = true
        
    }
    
    func makeSelectionButton(_ button: UIButton) {
        
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
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
    
    @IBAction func grayPressed(_ sender: UIButton) {
        color = "purple"
        grayButton.backgroundColor = UIColor.blue
        blueButton.backgroundColor = nil
        redButton.backgroundColor = nil
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = nil
    }
    
    @IBAction func bluePressed(_ sender: UIButton) {
        color = "teal"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = UIColor.blue
        redButton.backgroundColor = nil
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = nil
        
    }
    
    @IBAction func redPressed(_ sender: UIButton) {
        color = "red"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = nil
        redButton.backgroundColor = UIColor.blue
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = nil
    }
    
    @IBAction func greenPressed(_ sender: Any) {
        color = "green"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = nil
        redButton.backgroundColor = nil
        greenButton.backgroundColor = UIColor.blue
        orangeButton.backgroundColor = nil
    }
    
    @IBAction func orangePressed(_ sender: UIButton) {
        color = "orange"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = nil
        redButton.backgroundColor = nil
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = UIColor.blue
    }
    
    @IBAction func progressPressed(_ sender: UIButton) {
        type = "Progressive"
        progressiveButton.backgroundColor = UIColor.systemTeal
        oneTimeButton.backgroundColor = UIColor.lightGray
        totalTextField.isHidden = false
        totalLabel.isHidden = false
    }
    
    @IBAction func oneTimePressed(_ sender: UIButton) {
        type = "One Time"
        progressiveButton.backgroundColor = UIColor.lightGray
        oneTimeButton.backgroundColor = UIColor.systemTeal
        totalTextField.isHidden = true
        totalLabel.isHidden = true
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        saveGoal()
    
        delay(0.5) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func saveGoal() {
        
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goals Index").getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    let goalIndex = (dataDescription["index"])!
                    
                    db.collection("\(userID)").document("Goal\(goalIndex)").setData([
                        "task" : self.taskTextView.text ?? "",
                        "color" : self.color,
                        "type" : self.type,
                        "total" : self.totalTextField.text ?? "",
                        "index" : goalIndex,
                        "progress" : 0
                    ])
                    
                    GoalsViewController.taskNameArray.append(self.taskTextView.text)
                    
                    db.collection("\(userID)").document("Goals Index").setData([
                        "index" : dataDescription["index"] as! Int + 1
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
}
