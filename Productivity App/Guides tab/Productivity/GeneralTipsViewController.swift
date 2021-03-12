//
//  GeneralTipsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class GeneralTipsViewController: UIViewController {

    @IBOutlet weak var stressV: UIView!
    
    @IBOutlet weak var stressB: UIButton!
    
    @IBOutlet weak var prodV: UIView!
    
    @IBOutlet weak var prodB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let b = stressB {
            makeButtonGood(b, stressV)
            makeButtonGood(prodB, prodV)
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
    
    @IBAction func stressPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tipsToStress", sender: self)
    }
    
    @IBAction func prodPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tipsToIncreaseProd", sender: self)
    }
    
}
