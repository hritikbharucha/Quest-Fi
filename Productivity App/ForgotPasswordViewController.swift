//
//  ForgotPasswordViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 8/27/21.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var emailTextField: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        sendBtn.layer.cornerRadius = 20
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if !emailTextField.text!.isEmpty {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter an email.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
