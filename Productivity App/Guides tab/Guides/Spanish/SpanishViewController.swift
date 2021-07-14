//
//  SpanishViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class SpanishViewController: UIViewController {

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
    
    @IBAction func span12Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "spanTo12", sender: self)
    }
    
    @IBAction func span34Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "spanTo34", sender: self)
    }
    
    @IBAction func span56Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "spanTo56", sender: self)
    }
    
}
