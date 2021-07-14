//
//  Span34ViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class Span34ViewController: UIViewController {
    
    @IBOutlet var porView: UIView!
    
    @IBOutlet var porButton: UIButton!
    
    @IBOutlet var pretView: UIView!
    
    @IBOutlet var pretButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(porButton, porView)
        makeButtonGood(pretButton, pretView)
        
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
    
    @IBAction func porPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "34ToPor", sender: self)
    }
    
    @IBAction func pretPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "34ToPret", sender: self)
    }
    
}
