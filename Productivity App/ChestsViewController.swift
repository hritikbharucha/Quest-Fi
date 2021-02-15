//
//  ChestsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/14/21.
//

import UIKit

class ChestsViewController: UIViewController {
    
    @IBOutlet weak var commonView: UIView!
    
    @IBOutlet weak var commonButton: UIButton!
    
    @IBOutlet weak var commonCount: UILabel!
    
    @IBOutlet weak var rareView: UIView!
    
    @IBOutlet weak var rareButton: UIButton!
    
    @IBOutlet weak var rareCount: UILabel!
    
    @IBOutlet weak var magicalView: UIView!
    
    @IBOutlet weak var magicalButton: UIButton!
    
    @IBOutlet weak var magicalCount: UILabel!
    
    @IBOutlet weak var openAllButton: UIButton!
    
    @IBOutlet weak var openAllView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(commonButton, commonView)
        makeButtonGood(rareButton, rareView)
        makeButtonGood(magicalButton, magicalView)
        
        commonButton.layer.cornerRadius = 0
        
        makeCircle(commonCount)
        makeCircle(rareCount)
        makeCircle(magicalCount)
        
        makeButtonLabelGood(openAllButton, "Open All")
        
        makeButtonGood(openAllButton, openAllView)
    }
    
    func makeButtonLabelGood(_ label: UIButton,_ string: String) {
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 30),
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ] as [NSAttributedString.Key : Any]
        
        let text = NSAttributedString(string: string, attributes: stringAttributes)
        
        label.setAttributedTitle(text, for: .normal)
    }
    
    func makeCircle(_ label: UILabel) {
        label.layer.cornerRadius = label.frame.size.height/2
        label.layer.masksToBounds = true
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
    
    func makeViewGood(_ containerView: UIView) {
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 20).cgPath
    }

}
