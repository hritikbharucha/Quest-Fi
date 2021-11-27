//
//  SettingsTableViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    let settings = ["Account", "Help", "About", "Log out"]

    override func viewDidLoad() {
        super.viewDidLoad()

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

        if (settings[indexPath.row] == "Log out") {
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
        } else if (settings[indexPath.row] == "Help") {
            self.performSegue(withIdentifier: "settingsToHelp", sender: self)
        } else if (settings[indexPath.row] == "About") {
            self.performSegue(withIdentifier: "settingsToAttributes", sender: self)
        }
    }

}
