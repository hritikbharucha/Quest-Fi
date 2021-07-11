//
//  ShopViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/12/21.
//

import UIKit
import Firebase

class ShopViewController: UIViewController {

    @IBOutlet weak var gpLogo: UILabel!
    
    @IBOutlet weak var gpLabel: UILabel!
    
    @IBOutlet weak var commonView: UIView!
    
    @IBOutlet weak var commonBtn: UIButton!
    
    @IBOutlet weak var commonGP: UILabel!
    
    @IBOutlet weak var commonLabel: UILabel!
    
    @IBOutlet weak var commonImage: UIImageView!
    
    @IBOutlet weak var commonPrice: UILabel!
    
    @IBOutlet weak var rareView: UIView!
    
    @IBOutlet weak var rareBtn: UIButton!
    
    @IBOutlet weak var rareGP: UILabel!
    
    @IBOutlet weak var rareLabel: UILabel!
    
    @IBOutlet weak var rareImage: UIImageView!
    
    @IBOutlet weak var rarePrice: UILabel!
    
    @IBOutlet weak var magicalView: UIView!
    
    @IBOutlet weak var magicalBtn: UIButton!
    
    @IBOutlet weak var magicalGP: UILabel!
    
    @IBOutlet weak var magicalLabel: UILabel!
    
    @IBOutlet weak var magicalImage: UIImageView!
    
    @IBOutlet weak var magicalPrice: UILabel!
    
    var points = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGP(gpLogo, 35)
        setUpGP(commonGP, 25)
        setUpGP(rareGP, 25)
        setUpGP(magicalGP, 25)
        
        makeLabelGood(commonLabel, "Common Chest", 30)
        makeLabelGood(commonPrice, "10", 50)
        makeLabelGood(rareLabel, "Rare Chest", 30)
        makeLabelGood(rarePrice, "25", 50)
        makeLabelGood(magicalLabel, "Magical Chest", 30)
        makeLabelGood(magicalPrice, "100", 50)
        
        makeButtonGood(commonBtn, commonView)
        makeButtonGood(rareBtn, rareView)
        makeButtonGood(magicalBtn, magicalView)
        
    }
    
    override func viewDidLayoutSubviews() {
        setUpGP(gpLogo, gpLogo.frame.width/2)
        gpLogo.font = gpLogo.font.withSize(gpLogo.frame.width*2/3)
        gpLabel.font = gpLabel.font.withSize(gpLabel.frame.height*0.85)
        
        makeButtonGood(commonBtn, commonView)
        makeButtonGood(rareBtn, rareView)
        makeButtonGood(magicalBtn, magicalView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadGP()
    }
    
    func loadGP() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Goal Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    let pointsData = dataDesc["points"] as? Int ?? 0
                    
                    self.gpLabel.text = "\(pointsData)"
                    
                    self.points = pointsData
                }
            }
        }
    }
    
    func setUpGP(_ gp: UILabel, _ radius: CGFloat) {
        gp.layer.masksToBounds = true
        gp.layer.cornerRadius = radius
        gp.layer.borderWidth = 2
        gp.layer.borderColor = UIColor.black.cgColor
    }
    
    func makeLabelGood(_ label: UILabel,_ string: String,_ size: CGFloat) {
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: size),
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
    
    func purchaseCommonChest() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            let ref = db.collection("\(userID)").document("Chest Data")
            
            ref.getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    let common = dataDesc["Common Chests"] as? Int ?? 0
                    
                    ref.updateData([
                        "Common Chests" : common+1
                    ])
                } else {
                    ref.setData([
                        "Common Chests" : 1,
                        "Rare Chests" : 0,
                        "Magical Chests" : 0
                    ])
                }
            }
            
            let ref2 = db.collection("\(userID)").document("Goal Data")
            
            ref2.updateData([
                "points" : points-10
            ])
            
            loadGP()
        }
    }
    
    func purchaseRareChest() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            let ref = db.collection("\(userID)").document("Chest Data")
            
            ref.getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    let rare = dataDesc["Rare Chests"] as? Int ?? 0
                    
                    ref.updateData([
                        "Rare Chests" : rare+1
                    ])
                } else {
                    ref.setData([
                        "Common Chests" : 0,
                        "Rare Chests" : 1,
                        "Magical Chests" : 0
                    ])
                }
            }
            
            let ref2 = db.collection("\(userID)").document("Goal Data")
            
            ref2.updateData([
                "points" : points-25
            ])
            
            loadGP()
        }
    }
    
    func purchaseMagicalChest() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            let ref = db.collection("\(userID)").document("Chest Data")
            
            ref.getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    let magical = dataDesc["Magical Chests"] as? Int ?? 0
                    
                    ref.updateData([
                        "Magical Chests" : magical+1
                    ])
                } else {
                    ref.setData([
                        "Common Chests" : 0,
                        "Rare Chests" : 0,
                        "Magical Chests" : 1
                    ])
                }
            }
            
            let ref2 = db.collection("\(userID)").document("Goal Data")
            
            ref2.updateData([
                "points" : points-100
            ])
            
            loadGP()
        }
    }
    
    @IBAction func commonPressed(_ sender: UIButton) {
        
        if points < 10 {
            let alert = UIAlertController(title: "Insufficent Funds", message: "You do not have enough goal points to purchase a common chest.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Purchase Confirmation", message: "Are you sure you want to purchase common chest for 10 goal points?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                    case .default:
                        self.purchaseCommonChest()
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func rarePressed(_ sender: UIButton) {
        if points < 25 {
            let alert = UIAlertController(title: "Insufficent Funds", message: "You do not have enough goal points to purchase a rare chest.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Purchase Confirmation", message: "Are you sure you want to purchase rare chest for 25 goal points?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                    case .default:
                        self.purchaseRareChest()
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func magicalPressed(_ sender: UIButton) {
        if points < 100 {
            let alert = UIAlertController(title: "Insufficent Funds", message: "You do not have enough goal points to purchase a magical chest.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Purchase Confirmation", message: "Are you sure you want to purchase magical chest for 100 goal points?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                    case .default:
                        self.purchaseMagicalChest()
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("NEW STUFF ADDED")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
