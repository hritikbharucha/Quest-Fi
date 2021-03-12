//
//  CSViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class CSViewController: UIViewController {

    @IBOutlet weak var javaView: UIView!
    
    @IBOutlet weak var javaButton: UIButton!
    
    @IBOutlet weak var swiftView: UIView!
    
    @IBOutlet weak var swiftButton: UIButton!
    
    @IBOutlet weak var htmlcssView: UIView!
    
    @IBOutlet weak var htmlcssButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(javaButton, javaView)
        makeButtonGood(swiftButton, swiftView)
        makeButtonGood(htmlcssButton, htmlcssView)
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
