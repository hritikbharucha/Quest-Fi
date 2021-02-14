//
//  SignUpViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField:
        UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        if let email = emailAddressTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.extendedLayoutIncludesOpaqueBars = true
        
        passwordTextField.textContentType = .oneTimeCode
        
        signUpButton.layer.cornerRadius = 10
    }


}
