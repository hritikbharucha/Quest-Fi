//
//  AddGoalsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/23/21.
//

import UIKit
import Firebase

class AddGoalsViewController: UIViewController {
    
//    @IBOutlet weak var progressiveButton: UIButton!
//
//    @IBOutlet weak var progressiveView: UIView!
    
//    @IBOutlet weak var oneTimeButton: UIButton!
//
//    @IBOutlet weak var oneTimeView: UIView!
//
//    @IBOutlet weak var totalTextField: UITextField!
//
//    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var grayButton: UIButton!
    
    @IBOutlet weak var purpleButton: UIButton!
    
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var orangeButton: UIButton!
    
    @IBOutlet weak var grayView: UIView!
    
    @IBOutlet weak var purpleView: UIView!
    
    @IBOutlet weak var blueView: UIView!
    
    @IBOutlet weak var redView: UIView!
    
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var orangeView: UIView!
    
    @IBOutlet weak var taskTextView: UITextView!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var frequencyPicker: UIPickerView!
    
    @IBOutlet weak var chooseDateTimeLabel: UILabel!
    
    @IBOutlet weak var dateTimeSwitch: UISwitch!
    
//    var userID = ""
    
    open var color = "gray"
    
    open var text = ""
    
    open var total = ""
    
    open var type = "One Time"
    
    var frequencyArray = ["Never", "Daily", "Weekly"]
    
    var date = Date()
    
    var viewHeight : CGFloat = 896
    var viewWidth : CGFloat = 414
    
    let selectionColor = UIColor(red: 64/255.0, green: 143/255.0, blue: 245/255.0, alpha: 1.0)
    
    let myPicker: MyDatePicker = {
        let v = MyDatePicker()
        return v
    }()
    let myButton: UIButton = {
        let v = UIButton()
        v.setTitle("Select date & time", for: [])
        v.setTitleColor(.black, for: .normal)
        v.setTitleColor(.lightGray, for: .highlighted)
        v.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        v.layer.cornerRadius = 15
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
//        userID = Auth.auth().currentUser!.uid
        
//        let db = Firestore.firestore()
        
//        if let userID = Auth.auth().currentUser?.uid {
//            db.collection("\(userID)").document("Goals Index").getDocument { (document, error) in
//                if let document = document, document.exists {
//                    print("Document does exist")
//                } else {
//                    db.collection("\(userID)").document("Goals Index").setData([
//                        "index" : 0
//                    ])
//                }
//            }
//        }
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width
        
        myButton.layer.cornerRadius = (15/414)*viewWidth
        
        frequencyPicker.dataSource = self
        frequencyPicker.delegate = self
        
        grayButton.backgroundColor = selectionColor
        
        taskTextView.layer.borderColor = UIColor.black.cgColor
        taskTextView.layer.borderWidth = (2/414)*viewWidth
        
    }
    
    override func viewDidLayoutSubviews() {
        setUpDatePicker()
        
        makeButtonGood(addButton, addView)
        
        makeSelectionButton(grayButton)
        makeSelectionButton(purpleButton)
        makeSelectionButton(blueButton)
        makeSelectionButton(redButton)
        makeSelectionButton(greenButton)
        makeSelectionButton(orangeButton)
    }
    
    func setUpDatePicker() {
        [myButton, myPicker].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            // custom picker view should cover the whole view
            myPicker.topAnchor.constraint(equalTo: g.topAnchor),
            myPicker.leadingAnchor.constraint(equalTo: g.leadingAnchor),
            myPicker.trailingAnchor.constraint(equalTo: g.trailingAnchor),
            myPicker.bottomAnchor.constraint(equalTo: g.bottomAnchor),
            
            myButton.centerXAnchor.constraint(equalTo: g.centerXAnchor),
            myButton.bottomAnchor.constraint(equalTo: chooseDateTimeLabel.bottomAnchor, constant: (65/896)*viewHeight),
            myButton.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.5),
            myButton.heightAnchor.constraint(equalToConstant: (40/896)*viewHeight),
            
        ])
        
        // hide custom picker view
        myPicker.isHidden = true
        
        // add closures to custom picker view
        myPicker.dismissClosure = { [weak self] in
            guard let self = self else {
                return
            }
            self.myPicker.isHidden = true
        }
        myPicker.changeClosure = { [weak self] val in
            guard let self = self else {
                return
            }
            print(val)
            self.date = val
            // do something with the selected date
        }
        
        // add button action
        myButton.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
    }
    
    @IBAction func dateTimeSwitchPressed(_ sender: UISwitch) {
        if dateTimeSwitch.isOn {
            myButton.isHidden = false
        } else {
            myButton.isHidden = true
        }
    }
    
    @objc func tap(_ sender: Any) {
        myPicker.isHidden = false
    }
    
    func makeSelectionButton(_ button: UIButton) {
        
        button.layer.cornerRadius = (12/414)*viewWidth
        button.clipsToBounds = true
        button.layer.borderWidth = (1/414)*viewWidth
        button.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = (0.2/414)*viewWidth
        containerView.layer.cornerRadius = (10/414)*viewWidth
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: (10/414)*viewWidth).cgPath
        button.clipsToBounds = true
        button.layer.cornerRadius = (10/414)*viewWidth
    }
    
    @IBAction func purplePressed(_ sender: UIButton) {
        color = "purple"
        purpleButton.backgroundColor = selectionColor
        blueButton.backgroundColor = nil
        redButton.backgroundColor = nil
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = nil
        grayButton.backgroundColor = nil
    }
    
    @IBAction func grayPressed(_ sender: UIButton) {
        color = "gray"
        grayButton.backgroundColor = selectionColor
        blueButton.backgroundColor = nil
        redButton.backgroundColor = nil
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = nil
        purpleButton.backgroundColor = nil
    }
    
    @IBAction func bluePressed(_ sender: UIButton) {
        color = "teal"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = selectionColor
        redButton.backgroundColor = nil
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = nil
        purpleButton.backgroundColor = nil
    }
    
    @IBAction func redPressed(_ sender: UIButton) {
        color = "red"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = nil
        redButton.backgroundColor = selectionColor
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = nil
        purpleButton.backgroundColor = nil
    }
    
    @IBAction func greenPressed(_ sender: Any) {
        color = "green"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = nil
        redButton.backgroundColor = nil
        greenButton.backgroundColor = selectionColor
        orangeButton.backgroundColor = nil
        purpleButton.backgroundColor = nil
    }
    
    @IBAction func orangePressed(_ sender: UIButton) {
        color = "orange"
        grayButton.backgroundColor = nil
        blueButton.backgroundColor = nil
        redButton.backgroundColor = nil
        greenButton.backgroundColor = nil
        orangeButton.backgroundColor = selectionColor
        purpleButton.backgroundColor = nil
    }
    
//    @IBAction func progressPressed(_ sender: UIButton) {
//        type = "Progressive"
//        progressiveButton.backgroundColor = UIColor.systemTeal
//        oneTimeButton.backgroundColor = UIColor.lightGray
//        totalTextField.isHidden = false
//        totalLabel.isHidden = false
//    }
//
//    @IBAction func oneTimePressed(_ sender: UIButton) {
//        type = "One Time"
//        progressiveButton.backgroundColor = UIColor.lightGray
//        oneTimeButton.backgroundColor = UIColor.systemTeal
//        totalTextField.isHidden = true
//        totalLabel.isHidden = true
//    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        saveGoal {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func saveGoal(completion: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        
        let code = NanoID.new()
        
        GoalsViewController.taskNameArray.append(["name" : self.taskTextView.text, "code" : code])
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Names").setData([
                "tasks" : GoalsViewController.taskNameArray
            ])
        }
        
        if dateTimeSwitch.isOn {
            if let userID = Auth.auth().currentUser?.uid {
                db.collection("\(userID)").document("\(code)").setData([
                    "task" : self.taskTextView.text ?? "",
                    "color" : self.color,
                    "frequency" : self.frequencyArray[self.frequencyPicker.selectedRow(inComponent: 0)],
                    "dateAndTime" : self.date,
                    "scheduled" : true
                    //                        "type" : self.type,
                    //                        "total" : self.totalTextField.text ?? "",
                    //                        "index" : goalIndex
                    //                        "progress" : 0
                ])
            }
            
            if self.date.get(.day) == Date().get(.day) {
                GoalsViewController.todayNameArray.append(["name" : self.taskTextView.text, "code" : code])
            }
        } else {
            if let userID = Auth.auth().currentUser?.uid {
                db.collection("\(userID)").document("\(code)").setData([
                    "task" : self.taskTextView.text ?? "",
                    "color" : self.color,
                    "frequency" : self.frequencyArray[self.frequencyPicker.selectedRow(inComponent: 0)],
                    "dateAndTime" : self.date,
                    "scheduled" : false
                ])
            }
            
            GoalsViewController.unscheduledNameArray.append(["name" : self.taskTextView.text, "code" : code])
        }
        
        if self.frequencyArray[self.frequencyPicker.selectedRow(inComponent: 0)] == "Daily" {
            self.setLastDate(code)
            GoalsViewController.dailyNameArray.append(["name" : self.taskTextView.text, "code" : code])
            
            if let userID = Auth.auth().currentUser?.uid {
                db.collection("\(userID)").document("Daily Names").setData([
                    "dailyNames" : GoalsViewController.dailyNameArray
                ])
            }
        } else if self.frequencyArray[self.frequencyPicker.selectedRow(inComponent: 0)] == "Weekly" {
            self.setLastDate(code)
            GoalsViewController.weeklyNameArray.append(["name" : self.taskTextView.text, "code" : code])
            
            if let userID = Auth.auth().currentUser?.uid {
                db.collection("\(userID)").document("Weekly Names").setData([
                    "weeklyNames" : GoalsViewController.weeklyNameArray
                ])
            }
        }
        
        completion()
        
    }
    
    func setLastDate(_ code: String) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("\(code)").setData(["lastDate" : self.date], mergeFields: ["lastDate"])
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
}

extension AddGoalsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencyArray[row]
    }

}
