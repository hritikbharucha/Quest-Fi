//
//  MathViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class MathViewController: UIViewController {

    @IBOutlet weak var preCalcView: UIView!
    
    @IBOutlet weak var preCalcButton: UIButton!
    
    @IBOutlet weak var apCalcView: UIView!
    
    @IBOutlet weak var apCalcButton: UIButton!
    
    @IBOutlet weak var algebraView: UIView!
    
    @IBOutlet weak var algebraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(preCalcButton, preCalcView)
        makeButtonGood(apCalcButton, apCalcView)
        makeButtonGood(algebraButton, algebraView)
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
