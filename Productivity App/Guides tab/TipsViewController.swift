//
//  TipsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit

class TipsViewController: UIViewController {
    
    @IBOutlet weak var labelWithWords: UILabel!
    
    @IBOutlet weak var forYouButton: UIButton!
    
    @IBOutlet weak var guidesButton: UIButton!
    
    @IBOutlet weak var productivityButton: UIButton!
    
    @IBOutlet weak var guidesView: UIView!
    
    @IBOutlet weak var productivityView: UIView!
    
    @IBOutlet weak var forYouView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeButtonGood(forYouButton, forYouView)
        makeButtonGood(guidesButton, guidesView)
        makeButtonGood(productivityButton, productivityView)
        
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
    
    @IBAction func forYouPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tipsToForYou", sender: self)
    }
    
    @IBAction func guidesPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tipsToGuides", sender: self)
    }
    
    @IBAction func prodPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tipsToProductivity", sender: self)
    }
    
}
