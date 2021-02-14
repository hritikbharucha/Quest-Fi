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
                } else {
                    self.performSegue(withIdentifier: "logInToHome", sender: self)
                }
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.extendedLayoutIncludesOpaqueBars = true
        
        passwordTextField.textContentType = .oneTimeCode
        
        loginButton.layer.cornerRadius = 10
        
        signUpButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func googleSignInPressed(_ sender: UIButton) {
        
         GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let authentication = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential, completion: { (user, error) -> Void in
                if error != nil {
                    print("Problem at signing in with google with error : \(error!)")
                } else if error == nil {
                    print("user successfully signed in through GOOGLE! uid:\(Auth.auth().currentUser!.uid)")
                    print("signed in")
                    self.performSegue(withIdentifier: "logInToHome", sender: self)
                }
            })
        }
    }
    
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url)
    }

}
