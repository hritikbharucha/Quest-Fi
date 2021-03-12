//
//  HistoryViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var worldView: UIView!
    
    @IBOutlet weak var worldButton: UIButton!
    
    @IBOutlet weak var usView: UIView!
    
    @IBOutlet weak var usButton: UIButton!
    
    @IBOutlet weak var govtView: UIView!
    
    @IBOutlet weak var govtButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(worldButton, worldView)
        makeButtonGood(usButton, usView)
        makeButtonGood(govtButton, govtView)
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
