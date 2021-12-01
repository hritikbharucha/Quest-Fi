//
//  SettingsTableViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var settings = ["Privacy Policy", "Account", "Help", "About", "Log out"]
    
    var isGuest = false

    override func viewDidLoad() {
        super.viewDidLoad()

        isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        
        if !isGuest {
            settings.append("Delete Account")
            settingsTableView.reloadData()
        }
    }
    
    func dismissViewControllers() {

        guard let vc = self.presentingViewController else { return }

        while (vc.presentingViewController != nil) {
            print("Dismissing view controllers")
            vc.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)

        if (settings[indexPath.row] == "Log out") || (settings[indexPath.row] == "Delete Account") {
            cell.textLabel?.textColor = UIColor.red
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        
        cell.textLabel?.text = settings[indexPath.row]
        cell.accessoryType = .disclosureIndicator
//        cell.backgroundColor = UIColor(red: 0xB9, green: 0xEA, blue: 0xFD, alpha: 1) 

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (settings[indexPath.row] == "Account") {
            self.performSegue(withIdentifier: "settingsToProfile", sender: self)
        } else if (settings[indexPath.row] == "Log out") {
            if !isGuest {
                do {
                    try Auth.auth().signOut()
                    print("Signed out")
                    
    //                self.navigationController?.popToRootViewController(animated: true)
                    
                    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)

                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }
            } else {
                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(false, forKey: "isGuest")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
            }
            
        } else if (settings[indexPath.row] == "Help") {
            self.performSegue(withIdentifier: "settingsToHelp", sender: self)
        } else if (settings[indexPath.row] == "About") {
            self.performSegue(withIdentifier: "settingsToAttributes", sender: self)
        } else if (settings[indexPath.row] == "Privacy Policy") {
            self.performSegue(withIdentifier: "settingsToPrivacy", sender: self)
        } else if (settings[indexPath.row] == "Delete Account") {
            
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete your account? You will lose all data on this account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    Auth.auth().currentUser?.delete(completion: { error in
                        if let error = error {
                            print("error deleting account: \(error)")
                            let alert = UIAlertController(title: "Error", message: "Error deleting account, please try again later.", preferredStyle: .alert)
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
                        } else {
                            print("account deleted")
                            
                            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                            
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
                        }
                    })
                    
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
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }

}
