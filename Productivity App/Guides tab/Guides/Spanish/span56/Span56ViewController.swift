//
//  Span56ViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class Span56ViewController: UIViewController {
    
    @IBOutlet weak var futView: UIView!
    
    @IBOutlet weak var futButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(futButton, futView)
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
    
    @IBAction func futPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "56ToFut", sender: self)
    }
    
}
