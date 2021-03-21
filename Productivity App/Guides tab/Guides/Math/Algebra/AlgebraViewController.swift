//
//  AlgebraViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class AlgebraViewController: UIViewController {
    
    @IBOutlet weak var functionsView: UIView!
    
    @IBOutlet weak var functionsButton: UIButton!
    
    @IBOutlet weak var sysView: UIView!
    
    @IBOutlet weak var sysButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(functionsButton, functionsView)
        makeButtonGood(sysButton, sysView)
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
    
    @IBAction func typesPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "algebraToTypes", sender: self)
    }
    
    @IBAction func systemsPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "algebraToSystems", sender: self)
    }
    
}
