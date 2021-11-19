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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterNameTextView.text = nameText
        characterNameTextView.delegate = self
        characterModelImage.image = UIImage(named: imageName ?? "hair1bluecrfalsechfalse")
        editBtn.isHidden = editHidden ?? false
        characterNameTextView.isEditable = editMode ?? false
        characterNameTextView.isUserInteractionEnabled = editMode ?? false
        characterNameTextView.isSelectable = editMode ?? false
        editBtn.tag = index ?? -1

        setUpButton(editBtn)
    }
    
    func setUpButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        print("NOW EDITING CHARACTER \(editBtn.tag+1)")
        
        self.performSegue(withIdentifier: "rewardsToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        EditCharacterViewController.name = nameText ?? "Character 1"
        EditCharacterViewController.model = imageName ?? "hair1bluecrfalsechfalse"
        EditCharacterViewController.character = "character\((index ?? 0) + 1)"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        EditCharacterViewController.name = textView.text
    }
    
}
