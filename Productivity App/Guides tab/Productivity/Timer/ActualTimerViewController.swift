//
//  ActualTimerViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/22/21.
//

import UIKit

class ActualTimerViewController: UIViewController {

    @IBOutlet weak var goStopView: UIView!
    
    @IBOutlet weak var goStopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(goStopButton, goStopView)
        goStopButton.backgroundColor = UIColor.green
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

    @IBAction func goStopPressed(_ sender: UIButton) {
        
        if goStopButton.backgroundColor == UIColor.green {
            
            //Begin timer here
            
            goStopButton.backgroundColor = UIColor.red
            goStopButton.setTitle("Stop", for: .normal)
            print("Stop")
            
        } else {
            
            //Stop timer here
            
            goStopButton.backgroundColor = UIColor.green
            goStopButton.setTitle("Go", for: .normal)
            print("Go")
            
        }
        
    }
    
}
