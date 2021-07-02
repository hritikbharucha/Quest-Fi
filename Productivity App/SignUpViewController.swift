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
        
        if passwordTextField.text == confirmPasswordTextField.text {
            if let email = emailAddressTextField.text, let password = passwordTextField.text {
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                  
                    if let e = error {
                        print(e)
                        
                        let err = e as NSError
                        
                        switch err.code {
                        case AuthErrorCode.weakPassword.rawValue:
                            print("wrong password")
                            
                            let alert = UIAlertController(title: "Error", message: "Password too weak.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
                            
                        case AuthErrorCode.invalidEmail.rawValue:
                            print("invalid email")
                            
                            let alert = UIAlertController(title: "Error", message: "Invalid email.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
                            
                        case AuthErrorCode.internalError.rawValue:
                            print("internal error")
                            
                            let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again later.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
                            
                        case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                            print("email is alreay in use")
                            
                            let alert = UIAlertController(title: "Error", message: "Email already in use.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
                            
                        default:
                            print("unknown error: \(err.localizedDescription)")
                            
                            let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again later.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
                        
                    } else {
                        let user = Auth.auth().currentUser
                        if let user = user {
                            let uid = user.uid
                            
                            let name = (self.firstNameTextField.text ?? "") + " " + (self.lastNameTextField.text ?? "")
                            
                            let db = Firestore.firestore()
                            
                            db.collection("\(uid)").document("User Data").setData([
                                "name" : name,
                                "username" : self.usernameTextField.text ?? "",
                                "phone number" : self.phoneNumberTextField.text ?? "",
                                "email" : self.emailAddressTextField.text ?? "",
                                "password" : self.passwordTextField.text ?? ""
                            ])
                        }
                        
//                        self.performSegue(withIdentifier: "signUpToHome", sender: self)
                        
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainNavigationController = storyboard.instantiateViewController(identifier: "MainNavigationController")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainNavigationController)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.extendedLayoutIncludesOpaqueBars = true
        
        passwordTextField.textContentType = .oneTimeCode
        
        signUpButton.layer.cornerRadius = 10
    }


}
