//
//  SettingsTableViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let settings = ["Account", "Notifications", "Attributes", "Buy premium", "Log out"]

    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.backgroundColor = UIColor(red: 0xB9, green: 0xEA, blue: 0xFD, alpha: 1) 

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (settings[indexPath.row] == "Buy premium") {
            self.performSegue(withIdentifier: "settingsToPremium", sender: self)
        }
    }

}
