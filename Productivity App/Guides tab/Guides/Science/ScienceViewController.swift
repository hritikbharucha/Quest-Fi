//
//  ScienceViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class ScienceViewController: UIViewController {

    @IBOutlet weak var physicsView: UIView!
    
    @IBOutlet weak var physicsButton: UIButton!
    
    @IBOutlet weak var biologyView: UIView!
    
    @IBOutlet weak var biologyButton: UIButton!
    
    @IBOutlet weak var chemistryView: UIView!
    
    @IBOutlet weak var chemistryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(physicsButton, physicsView)
        makeButtonGood(biologyButton, biologyView)
        makeButtonGood(chemistryButton, chemistryView)
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

}
