//
//  ChestsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/14/21.
//

import UIKit
import Firebase

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
    
    var color = UIColor.white
    var image = "hair1"
    
    var commonChests = 0
    var rareChests = 0
    var magicalChests = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeButtonGood(commonButton, commonView)
        makeButtonGood(rareButton, rareView)
        makeButtonGood(magicalButton, magicalView)
        
        commonButton.layer.cornerRadius = 0
        
        makeCircle(commonCount)
        makeCircle(rareCount)
        makeCircle(magicalCount)
        
    }
    
    func makeChestNoOpen() {
        self.commonCount.isHidden = true
        self.commonButton.isUserInteractionEnabled = false
        
        self.rareCount.isHidden = false
        self.rareButton.isUserInteractionEnabled = true
        
        self.magicalCount.isHidden = true
        self.magicalButton.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChestCount()
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
                    
                    self.commonChests = common
                    self.rareChests = rare
                    self.magicalChests = magical
                    
                    if common == 0 {
                        self.commonCount.isHidden = true
                        self.commonButton.isUserInteractionEnabled = false
                    } else {
                        self.commonCount.text = "\(common)"
                        self.commonCount.isHidden = false
                        self.commonButton.isUserInteractionEnabled = true
                    }
                    
                    if rare == 0 {
                        self.rareCount.isHidden = true
                        self.rareButton.isUserInteractionEnabled = false
                    } else {
                        self.rareCount.text = "\(rare)"
                        self.rareCount.isHidden = false
                        self.rareButton.isUserInteractionEnabled = true
                    }
                    
                    if magical == 0 {
                        self.magicalCount.isHidden = true
                        self.magicalButton.isUserInteractionEnabled = false
                    } else {
                        self.magicalCount.text = "\(magical)"
                        self.magicalCount.isHidden = false
                        self.magicalButton.isUserInteractionEnabled = true
                    }
                    
                } else {
                    print("Document does not exist")
                    
                    self.commonCount.isHidden = true
                    self.commonButton.isUserInteractionEnabled = false
                    
                    self.rareCount.isHidden = true
                    self.rareButton.isUserInteractionEnabled = false
                    
                    self.magicalCount.isHidden = true
                    self.magicalButton.isUserInteractionEnabled = false
                }
            }
        } else {
            print("Document does not exist")
            
            self.commonCount.isHidden = true
            self.commonButton.isUserInteractionEnabled = false
            
            self.rareCount.isHidden = true
            self.rareButton.isUserInteractionEnabled = false
            
            self.magicalCount.isHidden = true
            self.magicalButton.isUserInteractionEnabled = false
        }
    }
    
    func makeButtonLabelGood(_ label: UIButton,_ string: String) {
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 30)!,
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
        label.isHidden = true
        label.isUserInteractionEnabled = false
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
    
    func removeCommonChest() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Chest Data").updateData([
                "Common Chests" : commonChests-1
            ])
        }
    }
    
    func removeRareChest() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Chest Data").updateData([
                "Rare Chests" : rareChests-1
            ])
        }
    }
    
    func removeMagicalChest() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Chest Data").updateData([
                "Magical Chests" : magicalChests-1
            ])
        }
    }
    
    func getRandomCommon() {
        let random = Int.random(in: 2...5)
        
        image = "hair\(random)"
        
        color = UIColor.systemGray3
    }
    
    func getRandomRare() {
        image = "red"
        color = UIColor.blue
    }
    
    func getRandomEpic() {
        image = "chain"
        color = UIColor.purple
    }
    
    func getLegendary() {
        image = "crown"
        color = UIColor.yellow
    }
    
    func getCommonReward() {
        let random = Double.random(in: 0.0...100.0)
        
        if random <= 98 {
            getRandomCommon()
        } else if random <= 99 {
            getRandomRare()
        } else if random <= 99.9 {
            getRandomEpic()
        } else {
            getLegendary()
        }
        
        removeCommonChest()
        
        self.performSegue(withIdentifier: "chestToOpen", sender: self)
    }
    
    func getRareReward() {
        let random = Double.random(in: 0.0...100.0)
        
        if random <= 75 {
            getRandomRare()
        } else if random <= 90 {
            getRandomEpic()
        } else {
            getLegendary()
        }
        
        removeRareChest()
        
        self.performSegue(withIdentifier: "chestToOpen", sender: self)
    }
    
    func getMagicalReward() {
        let random = Double.random(in: 0.0...100.0)
        
        if random <= 10 {
            getRandomRare()
        } else if random <= 75 {
            getRandomEpic()
        } else {
            getLegendary()
        }
        
        removeMagicalChest()
        
        self.performSegue(withIdentifier: "chestToOpen", sender: self)
    }
    
    @IBAction func commonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Open Confirmation", message: "Are you sure you want to open one common chest?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.getCommonReward()
                
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
    
    @IBAction func rarePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Open Confirmation", message: "Are you sure you want to open one rare chest?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
                case .default:
                    self.getRareReward()
                
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
    
    @IBAction func magicalPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Open Confirmation", message: "Are you sure you want to open one magical chest?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
                case .default:
                    self.getMagicalReward()
                
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
    
    func addToCollection() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Rewards Data").setData([
                image : true
            ], mergeFields: [image])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        OpenChestViewController.bgColor = color
        OpenChestViewController.imageName = image
        addToCollection()
        loadChestCount()
    }
    
}
