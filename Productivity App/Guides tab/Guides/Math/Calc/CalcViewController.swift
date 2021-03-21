//
//  CalcViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class CalcViewController: UIViewController {
    
    @IBOutlet weak var derivativesView: UIView!
    
    @IBOutlet weak var derivativesButton: UIButton!
    
    @IBOutlet weak var integralsView: UIView!
    
    @IBOutlet weak var integralsButton: UIButton!
    
    @IBOutlet weak var limitsView: UIView!
    
    @IBOutlet weak var limitsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(derivativesButton, derivativesView)
        makeButtonGood(integralsButton, integralsView)
        makeButtonGood(limitsButton, limitsView)
        
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
    
    @IBAction func limitsPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "calcToLimits", sender: self)
    }
    
    @IBAction func derivativesPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "calcToDerivatives", sender: self)
    }
    
    @IBAction func integralsPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "calcToIntegrals", sender: self)
    }
    
}
