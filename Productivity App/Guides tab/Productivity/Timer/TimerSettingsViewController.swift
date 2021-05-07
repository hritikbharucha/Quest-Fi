//
//  TimerSettingsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/22/21.
//

import UIKit
import Firebase

class TimerSettingsViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(button1, view1)
        makeButtonGood(button2, view2)
        makeButtonGood(button3, view3)
        
        setup()
        
    }
    
    func setup() {
        let db = Firestore.firestore()
        
        db.collection("Goals").document("Timer").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? ["Error" : "Error"]
                let length = dataDescription["Length"] as! Int
                
                if length == 1 {
                    self.button1.backgroundColor = UIColor.systemTeal
                    self.button2.backgroundColor = UIColor.lightGray
                    self.button3.backgroundColor = UIColor.lightGray
                } else if length == 2 {
                    self.button1.backgroundColor = UIColor.lightGray
                    self.button2.backgroundColor = UIColor.systemTeal
                    self.button3.backgroundColor = UIColor.lightGray
                } else if length == 3 {
                    self.button1.backgroundColor = UIColor.lightGray
                    self.button2.backgroundColor = UIColor.lightGray
                    self.button3.backgroundColor = UIColor.systemTeal
                }
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
    
    @IBAction func button1Pressed(_ sender: UIButton) {
        
        button1.backgroundColor = UIColor.systemTeal
        button2.backgroundColor = UIColor.lightGray
        button3.backgroundColor = UIColor.lightGray
        saveTimer(1)
        
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        
        button1.backgroundColor = UIColor.lightGray
        button2.backgroundColor = UIColor.systemTeal
        button3.backgroundColor = UIColor.lightGray
        saveTimer(2)
        
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        
        button1.backgroundColor = UIColor.lightGray
        button2.backgroundColor = UIColor.lightGray
        button3.backgroundColor = UIColor.systemTeal
        saveTimer(3)
        
    }
    
    func saveTimer(_ length: Int) {
        let db = Firestore.firestore()
        
        db.collection("Goals").document("Timer").setData([
            "Length" : length
        ])
    }
    
}
