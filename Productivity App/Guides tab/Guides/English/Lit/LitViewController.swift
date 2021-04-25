//
//  LitViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class LitViewController: UIViewController {
    
    @IBOutlet weak var mcView: UIView!
    
    @IBOutlet weak var mcButton: UIButton!
    
    @IBOutlet weak var frView: UIView!
    
    @IBOutlet weak var frButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(mcButton, mcView)
        makeButtonGood(frButton, frView)
        
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
    
    @IBAction func mcPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "litToMC", sender: self)
    }
    
    @IBAction func frPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "litToFR", sender: self)
    }
    
}
