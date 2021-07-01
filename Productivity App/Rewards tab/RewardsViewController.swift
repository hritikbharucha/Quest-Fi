//
//  RewardsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase

class RewardsViewController: UIViewController {
    
    @IBOutlet weak var chestButton: UIButton!
    
    @IBOutlet weak var shopButton: UIButton!
    
    @IBOutlet weak var chestView: UIView!
    
    @IBOutlet weak var shopView: UIView!
    
    @IBOutlet weak var yourCollectionView: UIView!
    
    @IBOutlet weak var chestCount: UILabel!
    
    @IBOutlet weak var legendaryView: UIView!
    
    @IBOutlet weak var legendaryViewHolder: UIView!
    
    @IBOutlet weak var legendaryImage: UIImageView!
    
    @IBOutlet weak var epic1Image: UIImageView!
    
    @IBOutlet weak var epic2Image: UIImageView!
    
    @IBOutlet weak var epic3Image: UIImageView!
    
    @IBOutlet weak var rare1Image: UIImageView!
    
    @IBOutlet weak var rare2Image: UIImageView!
    
    @IBOutlet weak var rare3Image: UIImageView!
    
    @IBOutlet weak var rare4Image: UIImageView!
    
    @IBOutlet weak var rare5Image: UIImageView!
    
    @IBOutlet weak var rare6Image: UIImageView!
    
    @IBOutlet weak var common1Image: UIImageView!
    
    @IBOutlet weak var common2Image: UIImageView!
    
    @IBOutlet weak var common3Image: UIImageView!
    
    @IBOutlet weak var common4Image: UIImageView!
    
    @IBOutlet weak var common5Image: UIImageView!
    
    @IBOutlet weak var common6Image: UIImageView!
    
    @IBOutlet weak var common7Image: UIImageView!
    
    @IBOutlet weak var common8Image: UIImageView!
    
    @IBOutlet weak var common9Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideAllImages()
        
        makeCircle(chestCount)
        makeViewGood(yourCollectionView)
        outlineView(yourCollectionView)
        outlineView(legendaryView)
        makeViewGlow(legendaryViewHolder)
        makeButtonGood(chestButton, chestView)
        makeButtonGood(shopButton, shopView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChestCount()
        
        loadRewards()
    }
    
    func hideAllImages() {
        legendaryImage.isHidden = true
        epic1Image.isHidden = true
        epic2Image.isHidden = true
        epic3Image.isHidden = true
        rare1Image.isHidden = true
        rare2Image.isHidden = true
        rare3Image.isHidden = true
        rare4Image.isHidden = true
        rare5Image.isHidden = true
        rare6Image.isHidden = true
        common1Image.isHidden = true
        common2Image.isHidden = true
        common3Image.isHidden = true
        common4Image.isHidden = true
        common5Image.isHidden = true
        common6Image.isHidden = true
        common7Image.isHidden = true
        common8Image.isHidden = true
        common9Image.isHidden = true
    }
    
    func loadRewards() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            let ref = db.collection("\(userID)").document("Rewards Data")
            
            ref.getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    let legendary = dataDesc["legendary"] as? Bool ?? false
                    let epic1 = dataDesc["epic1"] as? Bool ?? false
                    let epic2 = dataDesc["epic2"] as? Bool ?? false
                    let epic3 = dataDesc["epic3"] as? Bool ?? false
                    let rare1 = dataDesc["rare1"] as? Bool ?? false
                    let rare2 = dataDesc["rare2"] as? Bool ?? false
                    let rare3 = dataDesc["rare3"] as? Bool ?? false
                    let rare4 = dataDesc["rare4"] as? Bool ?? false
                    let rare5 = dataDesc["rare5"] as? Bool ?? false
                    let rare6 = dataDesc["rare6"] as? Bool ?? false
                    let common1 = dataDesc["common1"] as? Bool ?? false
                    let common2 = dataDesc["common2"] as? Bool ?? false
                    let common3 = dataDesc["common3"] as? Bool ?? false
                    let common4 = dataDesc["common4"] as? Bool ?? false
                    let common5 = dataDesc["common5"] as? Bool ?? false
                    let common6 = dataDesc["common6"] as? Bool ?? false
                    let common7 = dataDesc["common7"] as? Bool ?? false
                    let common8 = dataDesc["common8"] as? Bool ?? false
                    let common9 = dataDesc["common9"] as? Bool ?? false
                    
                    self.legendaryImage.isHidden = !legendary
                    self.epic1Image.isHidden = !epic1
                    self.epic2Image.isHidden = !epic2
                    self.epic3Image.isHidden = !epic3
                    self.rare1Image.isHidden = !rare1
                    self.rare2Image.isHidden = !rare2
                    self.rare3Image.isHidden = !rare3
                    self.rare4Image.isHidden = !rare4
                    self.rare5Image.isHidden = !rare5
                    self.rare6Image.isHidden = !rare6
                    self.common1Image.isHidden = !common1
                    self.common2Image.isHidden = !common2
                    self.common3Image.isHidden = !common3
                    self.common4Image.isHidden = !common4
                    self.common5Image.isHidden = !common5
                    self.common6Image.isHidden = !common6
                    self.common7Image.isHidden = !common7
                    self.common8Image.isHidden = !common8
                    self.common9Image.isHidden = !common9
                } else {
                    ref.setData([
                        "legendary" : false,
                        "epic1" : false,
                        "epic2" : false,
                        "epic3" : false,
                        "rare1" : false,
                        "rare2" : false,
                        "rare3" : false,
                        "rare4" : false,
                        "rare5" : false,
                        "rare6" : false,
                        "common1" : false,
                        "common2" : false,
                        "common3" : false,
                        "common4" : false,
                        "common5" : false,
                        "common6" : false,
                        "common7" : false,
                        "common8" : false,
                        "common9" : false
                    ])
                }
            }
        }
    }
    
    func loadChestCount() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Chest Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    let common = dataDesc["Common Chests"] as? Int ?? 0
                    let rare = dataDesc["Rare Chests"] as? Int ?? 0
                    let magical = dataDesc["Magical Chests"] as? Int ?? 0
                    
                    let chests = common+rare+magical
                    
                    if chests == 0 {
                        self.chestCount.isHidden = true
                    } else {
                        self.chestCount.text = "\(chests)"
                        self.chestCount.isHidden = false
                    }
                    
                }
            }
        }
    }
    
    func makeCircle(_ label: UILabel) {
        label.layer.cornerRadius = label.frame.size.height/2
        label.layer.masksToBounds = true
        label.isHidden = true
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 20).cgPath        
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
    
    func makeViewGlow(_ containerView: UIView) {
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.red.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 7.5
        containerView.layer.cornerRadius = 25
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 25).cgPath
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
    
    @IBAction func chestPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "rewardsToChests", sender: self)
    }
}
