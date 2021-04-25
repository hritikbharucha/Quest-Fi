//
//  LangViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class LangViewController: UIViewController {
    
    @IBOutlet weak var raView: UIView!
    
    @IBOutlet weak var raButton: UIButton!
    
    @IBOutlet weak var synthView: UIView!
    
    @IBOutlet weak var synthButton: UIButton!
    
    @IBOutlet weak var argueView: UIView!
    
    @IBOutlet weak var argueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(raButton, raView)
        makeButtonGood(synthButton, synthView)
        makeButtonGood(argueButton, argueView)
        
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
    
    @IBAction func raPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "langToRA", sender: self)
    }
    
    @IBAction func synthesisPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "langToSynthesis", sender: self)
    }
    
    @IBAction func arguementPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "langToArgument", sender: self)
    }
    
}
