//
//  LogInViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleSignUpButton: UIButton!
    @IBOutlet weak var emailOrNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "logInToSignUp", sender: self)
        
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        
        if let email = emailOrNameTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    print("FAILED")
                    
                    let err = e as NSError
                    
                    switch err.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        print("wrong password")
                        
                        let alert = UIAlertController(title: "Error", message: "Wrong password.", preferredStyle: .alert)
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
                    print("SUCCESS")
//                    self.performSegue(withIdentifier: "logInToHome", sender: self)
                    
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainNavigationController = storyboard.instantiateViewController(identifier: "MainNavigationController")
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainNavigationController)
                }
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.extendedLayoutIncludesOpaqueBars = true
        
//        passwordTextField.textContentType = .oneTimeCode
        
        loginButton.layer.cornerRadius = (20/414)*view.frame.width
        emailOrNameTextField.layer.cornerRadius = (10/414)*view.frame.width
        passwordTextField.layer.cornerRadius = (10/414)*view.frame.width
        
        emailOrNameTextField.font = .systemFont(ofSize: (17/414)*view.frame.width)
        passwordTextField.font = .systemFont(ofSize: (17/414)*view.frame.width)
    }
    
    @IBAction func googleSignInPressed(_ sender: UIButton) {
        
         GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func forgotPressed(_ sender: UIButton) {
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if user == nil {
            return
        }
        
        if let authentication = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential, completion: { (user, error) -> Void in
                if error != nil {
                    print("Problem at signing in with google with error : \(error!)")
                    
                    let alert = UIAlertController(title: "Error", message: "Error signing in with Google.", preferredStyle: .alert)
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
                    
                } else if error == nil {
                    let user = Auth.auth().currentUser!
                    let userID = user.uid
                    
                    print("user successfully signed in through GOOGLE! uid:\(userID)")
                    print("signed in")
                    
                    let db = Firestore.firestore()
                    
                    let ref = db.collection(userID).document("User Data")
                    
                    ref.getDocument { document, error in
                        if let document = document, document.exists {
                            print("User has signed in before")
                        } else {
                            print("User first time")
                            
                            let username = "User\(Int.random(in: 1...1000000))"
                            
                            db.collection(userID).document("User Data").setData([
                                "email" : user.email ?? "",
                                "name" : user.displayName ?? "",
                                "username" : username
                            ])
                        }
                    }
                    
//                    self.performSegue(withIdentifier: "logInToHome", sender: self)
                    
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainNavigationController = storyboard.instantiateViewController(identifier: "MainNavigationController")
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainNavigationController)
                }
            })
        }
    }
    
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url)
    }

}


