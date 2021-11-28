//
//  LogInViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class LogInViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleSignUpButton: UIButton!
    @IBOutlet weak var emailOrNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var appleSignInView: UIView!
    
    let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
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
        
        loginButton.layer.cornerRadius = (10/414)*view.frame.width
        emailOrNameTextField.layer.cornerRadius = (10/414)*view.frame.width
        passwordTextField.layer.cornerRadius = (10/414)*view.frame.width
        
        emailOrNameTextField.font = .systemFont(ofSize: (17/414)*view.frame.width)
        passwordTextField.font = .systemFont(ofSize: (17/414)*view.frame.width)
        
        googleSignUpButton.layer.cornerRadius = (10/414)*view.frame.width
        
        setupAppleButton()
    }
    
    @IBAction func googleSignInPressed(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func setupAppleButton() {
        appleSignInView.layer.cornerRadius = (10/414)*view.frame.width
        appleSignInView.addSubview(appleButton)
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.topAnchor.constraint(equalTo: appleSignInView.topAnchor, constant: 0).isActive = true
        appleButton.bottomAnchor.constraint(equalTo: appleSignInView.bottomAnchor, constant: 0).isActive = true
        appleButton.trailingAnchor.constraint(equalTo: appleSignInView.trailingAnchor, constant: 0).isActive = true
        appleButton.leadingAnchor.constraint(equalTo: appleSignInView.leadingAnchor, constant: 0).isActive = true
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
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

@available(iOS 13.0, *)
extension LogInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print("errrrrrrrrrr")
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let username = "User\(Int.random(in: 1...1000000))"
                let email = user.email ?? ""
                let displayName = user.displayName ?? username
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                
                let ref = db.collection("\(uid)").document("User Data")
                
                ref.getDocument { document, error in
                    if let document = document, document.exists {
                        print("User has signed in before")
                    } else {
                        print("User first time")
                        
                        ref.setData([
                            "email": email,
                            "username": displayName,
                            "name": displayName
                        ])
                    }
                }
                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainNavigationController = storyboard.instantiateViewController(identifier: "MainNavigationController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainNavigationController)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LogInViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


