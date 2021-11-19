//
//  EditCharacterViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 11/6/21.
//

import UIKit
import Firebase

class EditCharacterViewController: UIViewController {
    
    static var character = "character1"
    static var name = "Character 1"
    static var model = "hair1bluecrfalsechfalse"
    
    var headgearList = ["hair1"]
    var topsList = ["blue"]
    var accessoriesList = [""]
    
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    var headgearPV = UIPickerView()
    var topsPV = UIPickerView()
    var accessoriesPV = UIPickerView()
    
    var hair = "hair1"
    var crown = false
    var settingUp = true
    var chain = false
    var top = "blue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePickerView(headgearPV, 1, 550)
        configurePickerView(topsPV, 2, 625)
        configurePickerView(accessoriesPV, 3, 700)
        
    }
    
    func setPickerViews(completion: @escaping () -> Void) {
        let hair = String(Self.model[...Self.model.index(Self.model.startIndex, offsetBy: 4)])
        if hair != "hair0" {
            
            
            // SIGN IN WITH APPLE AND CONSTRAINTS AND BUGS AND FOLLOW GUIDELINES SUBMIT SATURDAY
            
            
            
            self.headgearPV.selectRow(headgearList.firstIndex(of: hair) ?? 0, inComponent: 0, animated: false)
            self.pickerView(self.headgearPV, didSelectRow: headgearList.firstIndex(of: hair) ?? 0, inComponent: 0)
        } else {
            self.headgearPV.selectRow(headgearList.firstIndex(of: "crown") ?? 0, inComponent: 0, animated: false)
            self.pickerView(self.headgearPV, didSelectRow: headgearList.firstIndex(of: "crown") ?? 0, inComponent: 0)
        }
        
        print("model \(Self.model)")
        
        if Self.model.contains("red") {
            self.topsPV.selectRow(topsList.firstIndex(of: "red") ?? 0, inComponent: 0, animated: false)
            self.pickerView(self.topsPV, didSelectRow: topsList.firstIndex(of: "red") ?? 0, inComponent: 0)
        }
        
        if Self.model.contains("chtrue") {
            self.accessoriesPV.selectRow(accessoriesList.firstIndex(of: "chain") ?? 0, inComponent: 0, animated: false)
            self.pickerView(self.accessoriesPV, didSelectRow: accessoriesList.firstIndex(of: "chain") ?? 0, inComponent: 0)
        }
        
        completion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Rewards Data").setData([
                "\(Self.character)Name" : Self.name,
                "\(Self.character)Model" : Self.model
            ], mergeFields: ["\(Self.character)Name", "\(Self.character)Model"])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingUp = true
        loadAssets {
            self.headgearPV.reloadAllComponents()
            self.topsPV.reloadAllComponents()
            self.accessoriesPV.reloadAllComponents()
            self.setPickerViews {
                self.settingUp = false
            }
        }
        setUpCharacter()
    }
    
    func loadAssets(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        headgearList = ["hair1"]
        topsList = ["blue"]
        accessoriesList = [""]
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Rewards Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    for i in 2...5 {
                        if (dataDescription["hair\(i)"] as? Bool ?? false) {
                            self.headgearList.append("hair\(i)")
                        }
                    }
                    
                    if (dataDescription["red"] as? Bool ?? false) {
                        self.topsList.append("red")
                    }
                    
                    if (dataDescription["chain"] as? Bool ?? false) {
                        self.accessoriesList.append("chain")
                    }
                    
                    if (dataDescription["crown"] as? Bool ?? false) {
                        self.headgearList.append("crown")
                    }
                    
                    completion()
                } else {
                    print("Rewards document does not exist")
                    completion()
                }
            }
            
        }
    }
    
    func configurePickerView(_ pickerView: UIPickerView, _ tag: Int, _ y: Int) {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        self.view.addSubview(pickerView)
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        pickerView.frame = CGRect(x: 100, y: y, width: Int(view.bounds.width-150), height: 75)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = true
        let horizontalConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 100)
        let verticalConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -(view.bounds.height-CGFloat(y)))
        let widthConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.bounds.width-150)
        let heightConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 75)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func setUpCharacter() {
        
        guard let characterVC = detailViewControllerAt(index: 0) else {
            return
        }
        
        characterVC.view.frame = CGRect(x: (view.bounds.width/2)-200, y: 50, width: 400, height: 475)
        addChild(characterVC)
        view.addSubview(characterVC.view)
        
        characterVC.view.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: characterVC.view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: characterVC.view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 50)
        let widthConstraint = NSLayoutConstraint(item: characterVC.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400)
        let heightConstraint = NSLayoutConstraint(item: characterVC.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 475)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        characterVC.didMove(toParent: self)
        
    }
    
    func detailViewControllerAt(index: Int) -> CharactersViewController? {
        
        guard let charactersVC = storyboard?.instantiateViewController(withIdentifier: String(describing: CharactersViewController.self)) as? CharactersViewController else {
            return nil
        }
        
        charactersVC.index = index
        charactersVC.nameText = Self.name
        charactersVC.imageName = Self.model
        charactersVC.editHidden = true
        charactersVC.editMode = true
            
        return charactersVC
        
    }

}

extension EditCharacterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 75
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView.tag == 1 {
            return headgearList.count
        } else if pickerView.tag == 2 {
            return topsList.count
        } else {
            return accessoriesList.count
        }

    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        
        let itemImageView = UIImageView(frame: CGRect(x: 2.5, y: 2.5, width: 70, height: 70))

        if pickerView.tag == 1 {
            itemImageView.image = UIImage(named: headgearList[row])
        } else if pickerView.tag == 2 {
            itemImageView.image = UIImage(named: topsList[row])
        } else if pickerView.tag == 3 {
            itemImageView.image = UIImage(named: accessoriesList[row])
        }

        modeView.addSubview(itemImageView)

        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))

        return modeView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            hair = headgearList[pickerView.selectedRow(inComponent: 0)]
            if hair == "crown" {
                crown = true
            }
        } else if pickerView.tag == 2 {
            top = topsList[pickerView.selectedRow(inComponent: 0)]
        } else {
            if pickerView.selectedRow(inComponent: 0) == 1 {
                chain = true
            } else {
                chain = false
            }
        }
        
        if !settingUp {
            Self.model = "\(hair)\(top)cr\(crown)ch\(chain)"
        }
        
        setUpCharacter()
        
    }
}
