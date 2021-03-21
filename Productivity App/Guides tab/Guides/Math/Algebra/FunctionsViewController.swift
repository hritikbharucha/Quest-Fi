//
//  FunctionsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 3/17/21.
//

import UIKit

class FunctionsViewController: UIViewController {
    
    @IBOutlet weak var linearView: UIView!
    
    @IBOutlet weak var linearButton: UIButton!
    
    @IBOutlet weak var quadraticView: UIView!
    
    @IBOutlet weak var quadraticButton: UIButton!
    
    @IBOutlet weak var exponentialView: UIView!
    
    @IBOutlet weak var exponentialButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(linearButton, linearView)
        makeButtonGood(quadraticButton, quadraticView)
        makeButtonGood(exponentialButton, exponentialView)
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
    
    @IBAction func linearPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "typesToLinear", sender: self)
    }
    
    @IBAction func quadraticPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "typesToQuadratic", sender: self)
    }
    
    @IBAction func exponentialPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "typesToExponential", sender: self)
    }
    
}
