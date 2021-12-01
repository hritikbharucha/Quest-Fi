//
//  CharactersViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 11/3/21.
//

import UIKit

class CharactersViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var characterNameTextView: UITextView!
    
    @IBOutlet weak var characterModelImage: UIImageView!
    
    @IBOutlet weak var editBtn: UIButton!
    
    var index: Int?
    var nameText: String?
    var imageName: String?
    var editHidden: Bool?
    var editMode: Bool?
    
    var isGuest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        
        characterNameTextView.text = nameText
        characterNameTextView.delegate = self
        characterModelImage.image = UIImage(named: imageName ?? "hair1bluecrfalsechfalse")
        editBtn.isHidden = editHidden ?? false
        characterNameTextView.isEditable = editMode ?? false
        characterNameTextView.isUserInteractionEnabled = editMode ?? false
        characterNameTextView.isSelectable = editMode ?? false
        characterNameTextView.isScrollEnabled = false
        characterNameTextView.textContainer.maximumNumberOfLines = 1
        
//        if editMode ?? false {
//            print("EDITING NOW")
//            characterNameTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedTextView)))
//        }
       
//        if editMode ?? false {
//            characterNameTextView.becomeFirstResponder()
//        }
        
        editBtn.tag = index ?? -1

        setUpButton(editBtn)
    }
    
//    override func viewDidLayoutSubviews() {
//        characterNameTextView.textInputView.clipsToBounds = true
//    }
    
//    @objc func tappedTextView(gr: UIGestureRecognizer) {
//        self.characterNameTextView.isEditable = true
//        self.characterNameTextView.becomeFirstResponder()
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        self.characterNameTextView.isEditable = false
//    }
    
    func setUpButton(_ button: UIButton) {
        button.layer.cornerRadius = (15/414)*view.frame.width
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        if !isGuest {
            print("NOW EDITING CHARACTER \(editBtn.tag+1)")
            
            self.performSegue(withIdentifier: "rewardsToEdit", sender: self)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please make an account to edit character.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        EditCharacterViewController.name = nameText ?? "Character 1"
        EditCharacterViewController.model = imageName ?? "hair1bluecrfalsechfalse"
        EditCharacterViewController.character = "character\((index ?? 0) + 1)"
        EditCharacterViewController.index = (index ?? 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        EditCharacterViewController.name = textView.text
    }
    
}
