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
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var viewWidth : CGFloat = 414
    var viewHeight : CGFloat = 896
    
    var previousName = ""
    
    var notEditing = true
    
    var isGuest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width
        
        hideKeyboardWhenTappedAround()
        
        checkMode()

        if isGuest {
            editView.isHidden = true
            editButton.isHidden = true
            saveView.isHidden = true
            saveButton.isHidden = true
            cancelView.isHidden = true
            cancelButton.isHidden = true
            
            let name = UserDefaults.standard.string(forKey: "name") ?? "Guest User"
            nameTextField.text = name
            
            let username = UserDefaults.standard.string(forKey: "username")
            usernameTextField.text = username
        } else {
            getProfileData()
            emailTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        }
        
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let alert = UIAlertController(title: "Alert", message: "Sorry, email editing is not available.", preferredStyle: .alert)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setGradientColor(topView)
        setGradientColor(editButton)
        makeButtonGood(editButton, editView)
        makeButtonGood(cancelButton, cancelView)
        makeButtonGood(saveButton, saveView)
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
    }
    
    func disableEditing() {
        nameTextField.isUserInteractionEnabled = false
        usernameTextField.isUserInteractionEnabled = false
        phoneNumberTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
    }
    
    func enableEditing() {
        nameTextField.isUserInteractionEnabled = true
        usernameTextField.isUserInteractionEnabled = true
        phoneNumberTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
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
        containerView.layer.shadowRadius = (5/896)*viewHeight
        containerView.layer.cornerRadius = (20/896)*viewHeight
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: (20/896)*viewHeight).cgPath
        button.clipsToBounds = true
        button.layer.cornerRadius = (20/896)*viewHeight
    }
    
    func getProfileData() {
        
        let db = Firestore.firestore()
        print("user is \(Firebase.Auth.auth().currentUser?.uid)")
        if let userID = Firebase.Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("User Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    self.nameTextField.text = dataDesc["name"] as? String
                    self.usernameTextField.text = dataDesc["username"] as? String
                    self.phoneNumberTextField.text = dataDesc["phone number"] as? String
                    self.emailTextField.text = dataDesc["email"] as? String
                    
                }
            }
        }
    }
    
    func saveProfileData() {
        let db = Firestore.firestore()
        
        if let userID = Firebase.Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("User Data").setData([
                "name" : self.nameTextField.text ?? "",
                "username" : self.usernameTextField.text ?? "",
                "phone number" : self.phoneNumberTextField.text ?? "",
                "email" : self.emailTextField.text ?? ""
            ], mergeFields: ["name", "username", "phone number", "email"])
        }
        
        db.collection("Leaderboards").document("\(previousName)").getDocument { document, error in
            if let document = document, document.exists {
                
                let dataDesc = document.data() ?? ["error" : "error"]
                let name = self.usernameTextField.text ?? ""
                
                db.collection("Leaderboards").document("\(name)").setData([
                    "level" : dataDesc["level"] as? Int ?? 1,
                    "name" : name
                ])
                
                db.collection("Leaderboards").document("\(self.previousName)").delete()
                self.previousName = ""
            }
        }
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        
        previousName = usernameTextField.text ?? ""
//
//        let user = Auth.auth().currentUser
//        var credential: AuthCredential
//
//        print("email: \(self.emailTextField.text ?? "") password: \(self.passwordTextField.text ?? "")")
//        credential = EmailAuthProvider.credential(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
//        print("Credentials for email: \(credential)")
//
//        user?.reauthenticate(with: credential) { result, error  in
//            if result != nil {
//
//            print("Successfully reauthenticated")
//
//          } else {
//
//            print("error reauthenticating with email will try with google now")
//
//            if let googleUser = GIDSignIn.sharedInstance().currentUser {
//
//                credential = GoogleAuthProvider.credential(withIDToken: googleUser.authentication.idToken, accessToken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken)
//
//                user?.reauthenticate(with: credential) { result2, error2  in
//                    if result2 != nil {
//                        print("Successfully reauthenticated")
//                    } else {
//                        print("error reauthenticating")
//                    }
//                }
//            }
//
//          }
//        }
//
        notEditing = false
        checkMode()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        notEditing = true
        checkMode()
        
        getProfileData()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let db = Firestore.firestore()
        
        if previousName != usernameTextField.text {
            db.collection("Leaderboards").getDocuments { querySnapshot, err in
                
                if err != nil {
                    print("error")
                } else {
                    var count = querySnapshot!.count
                    
                    for document in querySnapshot!.documents {
                        if self.usernameTextField.text ?? "" == document.documentID {
                            let alert = UIAlertController(title: "Username not available", message: "Please choose a different username.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                switch action.style{
                                    case .default:
                                        print("default")
                                        
                                    case .cancel:
                                        print("cancel")
                                    
                                    case .destructive:
                                        print("destructive")
                                    
                                @unknown default:
                                    fatalError()
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        count -= 1
                    }
                    
                    if count == 0 {
                        self.saveProfileConfirmation()
                    }
                }
            }
        } else {
            self.saveProfileConfirmation()
        }
    }
    
    func saveProfileConfirmation() {
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
                
            @unknown default:
                print("unknown action")
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
