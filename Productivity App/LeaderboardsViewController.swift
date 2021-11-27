//
//  LeaderboardsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 6/10/21.
//

import UIKit
import Firebase

class LeaderboardsViewController: UIViewController {
    
    var rank = 1
    var index = -1
    var ranks = [String]()
    
    @IBOutlet weak var leaderboardsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leaderboardsTableView.dataSource = self
        leaderboardsTableView.delegate = self
        leaderboardsTableView.estimatedRowHeight = (43.5/896)*view.frame.height
        
        leaderboardsTableView.register(UINib(nibName: "Leaderboard", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRanks {
            self.leaderboardsTableView.reloadData()
        }
    }
    
    func setRanks(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        self.ranks = [String]()
        
        var count = 0
        
        let orderedUsers = db.collection("Leaderboards").order(by: "level", descending: true).limit(to: 10)
        print("Users ordered: \(orderedUsers)")
        
        orderedUsers.getDocuments { querySnapshot, error in
            if let error = error {
                print("error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let name = document.data()["name"] as? String ?? ""
                    self.ranks.append(name)
                    count += 1
                }
            }
            
            if count == querySnapshot!.count {
                completion()
            }
        }
    }

}

extension LeaderboardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Leaderboard
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        
        cell.selectionStyle = .none
        
        let db = Firestore.firestore()
        
        if indexPath.row < ranks.count {
            let doc = ranks[indexPath.row]
            
            db.collection("Leaderboards").document(doc).getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]

                    cell.nameLabel.text = dataDescription["name"] as? String ?? "Guest"
                    cell.levelLabel.text = "\(dataDescription["level"] ?? 0)"
                }
            }
        }
        
        return cell
    }
    
    
    
    
}
