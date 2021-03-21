//
//  PreCalcViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class PreCalcViewController: UIViewController {
    
    @IBOutlet weak var trigView: UIView!
    
    @IBOutlet weak var trigButton: UIButton!
    
    @IBOutlet weak var unitView: UIView!
    
    @IBOutlet weak var unitButton: UIButton!
    
    @IBOutlet weak var identitiesView: UIView!
    
    @IBOutlet weak var identitiesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(unitButton, unitView)
        makeButtonGood(trigButton, trigView)
        makeButtonGood(identitiesButton, identitiesView)
        
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
    
    @IBAction func unitPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "precalcToUnit", sender: self)
    }
    
    @IBAction func trigPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "precalcToTrig", sender: self)
    }
    
    @IBAction func identitiesPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "preCalcToIdentities", sender: self)
    }

}
