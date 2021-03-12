//
//  ShopViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/12/21.
//

import UIKit

class ShopViewController: UIViewController {

    @IBOutlet weak var dealsLabel: UILabel!
    
    @IBOutlet weak var chestsLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var special1: UIButton!
    
    @IBOutlet weak var special2: UIButton!
    
    @IBOutlet weak var special3: UIButton!
    
    @IBOutlet weak var chest1: UIButton!
    
    @IBOutlet weak var chest2: UIButton!
    
    @IBOutlet weak var chest3: UIButton!
    
    @IBOutlet weak var point1: UIButton!
    
    @IBOutlet weak var point2: UIButton!
    
    @IBOutlet weak var point3: UIButton!
    
    @IBOutlet weak var special1View: UIView!
    
    @IBOutlet weak var special2View: UIView!
    
    @IBOutlet weak var special3View: UIView!
    
    @IBOutlet weak var chest1View: UIView!
    
    @IBOutlet weak var chest2View: UIView!
    
    @IBOutlet weak var chest3View: UIView!
    
    @IBOutlet weak var point1View: UIView!
    
    @IBOutlet weak var point2View: UIView!
    
    @IBOutlet weak var point3View: UIView!
    
    @IBOutlet weak var commonLabel: UILabel!
    
    @IBOutlet weak var commonPriceLabel: UILabel!
    
    @IBOutlet weak var rareLabel: UILabel!
    
    @IBOutlet weak var rarePriceLabel: UILabel!
    
    @IBOutlet weak var magicalLabel: UILabel!
    
    @IBOutlet weak var magicalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeLabelGood(dealsLabel, "Special Offers")
        makeLabelGood(chestsLabel, "Chest Offers")
        makeLabelGood(pointsLabel, "Point Offers")
        
        makeDescLabelGood(commonLabel, "Common Chest")
        makePriceLabelGood(commonPriceLabel, "50")
        makeDescLabelGood(rareLabel, "Rare Chest")
        makePriceLabelGood(rarePriceLabel, "250")
        makeDescLabelGood(magicalLabel, "Magical Chest")
        makePriceLabelGood(magicalPriceLabel, "1000")
        
        makeButtonGood(special1, special1View)
        makeButtonGood(special2, special2View)
        makeButtonGood(special3, special3View)
        
        makeButtonGood(chest1, chest1View)
        makeButtonGood(chest2, chest2View)
        makeButtonGood(chest3, chest3View)
        
        makeButtonGood(point1, point1View)
        makeButtonGood(point2, point2View)
        makeButtonGood(point3, point3View)
        
    }
    
    func makePriceLabelGood(_ label: UILabel,_ string: String) {
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 20),
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ] as [NSAttributedString.Key : Any]
        
        label.attributedText = NSAttributedString(string: string, attributes: stringAttributes)
    }
    
    func makeDescLabelGood(_ label: UILabel,_ string: String) {
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 20),
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ] as [NSAttributedString.Key : Any]
        
        label.attributedText = NSAttributedString(string: string, attributes: stringAttributes)
    }
    
    func makeLabelGood(_ label: UILabel,_ string: String) {
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 30),
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ] as [NSAttributedString.Key : Any]
        
        label.attributedText = NSAttributedString(string: string, attributes: stringAttributes)
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
