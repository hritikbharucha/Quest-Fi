//
//  ProductivityViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class ProductivityViewController: UIViewController {

    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var tipsView: UIView!
    
    @IBOutlet weak var tipsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(timerButton, timerView)
        makeButtonGood(tipsButton, tipsView)
        
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

    @IBAction func tipsPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "productivityToGeneral", sender: self)
    }
    
    @IBAction func timerPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "prodSelectionToTimer", sender: self)
    }
    
}
