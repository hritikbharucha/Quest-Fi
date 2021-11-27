//
//  GeneralTipsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class GeneralTipsViewController: UIViewController {

    @IBOutlet weak var stressV: UIView!
    
    @IBOutlet weak var stressB: UIButton!
    
    @IBOutlet weak var prodV: UIView!
    
    @IBOutlet weak var prodB: UIButton!
    
    var viewWidth : CGFloat = 414
    var viewHeight : CGFloat = 896
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width

    }
    
    override func viewDidLayoutSubviews() {
        if let b = stressB {
            makeButtonGood(b, stressV)
            makeButtonGood(prodB, prodV)
        }
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = (5/896)*viewHeight
        containerView.layer.cornerRadius = (20/896)*viewHeight
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: (20/896)*viewHeight).cgPath
        button.clipsToBounds = true
        button.layer.cornerRadius = (20/896)*viewHeight
    }
    
    @IBAction func stressPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tipsToStress", sender: self)
    }
    
    @IBAction func prodPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tipsToIncreaseProd", sender: self)
    }
    
}
