//
//  RewardsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit

class RewardsViewController: UIViewController {
    
    @IBOutlet weak var chestButton: UIButton!
    
    @IBOutlet weak var shopButton: UIButton!
    
    @IBOutlet weak var chestView: UIView!
    
    @IBOutlet weak var shopView: UIView!
    
    @IBOutlet weak var yourCollectionView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeViewGood(yourCollectionView)
        outlineView(yourCollectionView)
        makeButtonGood(chestButton, chestView)
        makeButtonGood(shopButton, shopView)
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
    
    func outlineView(_ v: UIView) {
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = v.bounds
        maskLayer.path = UIBezierPath(roundedRect: v.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 25, height: 25)).cgPath
        v.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineWidth = 5
        borderLayer.frame = v.bounds
        v.layer.addSublayer(borderLayer)
        
    }
    
    
    @IBAction func shopPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "rewardsToShop", sender: self)
        
    }
    
}
