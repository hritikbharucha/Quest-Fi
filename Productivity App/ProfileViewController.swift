//
//  ProfileViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 5/22/21.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var eyeButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var secure = true
    var notEditing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        setGradientColor(topView)
        setGradientColor(editButton)
        
        makeButtonGood(editButton, editView)
        makeButtonGood(cancelButton, cancelView)
        makeButtonGood(saveButton, saveView)
        
        getProfileData()
        
        checkMode()
    }
    
    func checkMode() {
        cancelView.isHidden = notEditing
        cancelButton.isHidden = notEditing
        
        saveView.isHidden = notEditing
        saveButton.isHidden = notEditing
        
        editView.isHidden = !notEditing
        editButton.isHidden = !notEditing
        
        nameTextField.isUserInteractionEnabled = !notEditing
        usernameTextField.isUserInteractionEnabled = !notEditing
        phoneNumberTextField.isUserInteractionEnabled = !notEditing
        emailTextField.isUserInteractionEnabled = !notEditing
        passwordTextField.isUserInteractionEnabled = !notEditing
    }
    
    func disableEditing() {
        nameTextField.isUserInteractionEnabled = false
        usernameTextField.isUserInteractionEnabled = false
        phoneNumberTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
    }
    
    func enableEditing() {
        nameTextField.isUserInteractionEnabled = true
        usernameTextField.isUserInteractionEnabled = true
        phoneNumberTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
    }
    
    func setGradientColor(_ view: UIView) {
        
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 163/255, green: 163/255, blue: 255/255, alpha: 1).cgColor, UIColor(red: 120/255, green: 121/255, blue: 255/255, alpha: 1).cgColor]

        view.layer.insertSublayer(gradient, at: 0)
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
    
    func getProfileData() {
        
        let userID = Firebase.Auth.auth().currentUser!.uid
        print("USER ID IS RIGHT HERE \(userID)")
        
        let db = Firestore.firestore()
        let ref = db.collection("\(userID)").document("User Data")
        
        ref.getDocument { document, error in
            if let document = document, document.exists {
                let dataDesc = document.data() ?? ["error" : "error"]
                
                self.nameTextField.text = dataDesc["name"] as? String
                self.usernameTextField.text = dataDesc["username"] as? String
                self.phoneNumberTextField.text = dataDesc["phone number"] as? String
                self.emailTextField.text = dataDesc["email"] as? String
                self.passwordTextField.text = dataDesc["password"] as? String
                
            }
        }
        
    }
    
    func saveProfileData() {
        let db = Firestore.firestore()
        
        let userID = Firebase.Auth.auth().currentUser!.uid
                
        db.collection("\(userID)").document("User Data").updateData([
            "name" : self.nameTextField.text ?? "",
            "username" : self.usernameTextField.text ?? "",
            "phone number" : self.phoneNumberTextField.text ?? "",
            "email" : self.emailTextField.text ?? "",
            "password" : self.passwordTextField.text ?? ""
        ])
        
        Auth.auth().currentUser?.updateEmail(to: self.emailTextField.text ?? "", completion: { (error) in
            print("Error updating email: \(String(describing: error))")
        })
        
        Auth.auth().currentUser?.updatePassword(to: self.passwordTextField.text ?? "", completion: { (error) in
            print("Error updating password: \(String(describing: error))")
        })
    }
    
    @IBAction func eyePressed(_ sender: UIButton) {
        
        secure = !secure
        passwordTextField.isSecureTextEntry = secure
        
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        var credential: AuthCredential

        print("email: \(self.emailTextField.text ?? "") password: \(self.passwordTextField.text ?? "")")
        credential = EmailAuthProvider.credential(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
        print("Credentials for email: \(credential)")

        user?.reauthenticate(with: credential) { result, error  in
            if result != nil {
            
            print("Successfully reauthenticated")
            
          } else {
            
            print("error reauthenticating with email will try with google now")
            
            if let googleUser = GIDSignIn.sharedInstance().currentUser {
                
                credential = GoogleAuthProvider.credential(withIDToken: googleUser.authentication.idToken, accessToken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken)
                
                user?.reauthenticate(with: credential) { result2, error2  in
                    if result2 != nil {
                        print("Successfully reauthenticated")
                    } else {
                        print("error reauthenticating")
                    }
                }
            }
            
          }
        }
        
        notEditing = false
        checkMode()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        notEditing = true
        checkMode()
        
        getProfileData()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Saving Profile", message: "Are you sure you want to save your changes?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
                case .default:
                    
                    self.notEditing = true
                    self.checkMode()
                    self.saveProfileData()
                    
                case .cancel:
                    print("cancel")
                
                case .destructive:
                    print("destructive")
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            switch action.style{
                case .default:
                    print("default")
                
                case .cancel:
                    print("canceled")
                
                case .destructive:
                    print("destructive")
                
            @unknown default:
                print("unknown case for alert")
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}
