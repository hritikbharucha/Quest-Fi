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
        
        leaderboardsTableView.register(UINib(nibName: "Leaderboard", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        setRanks {
            print("Reloading data")
            self.leaderboardsTableView.reloadData()
        }
    }
    
    func setRanks(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Leaderboards").getDocuments { querySnapshot, err in
            if let err = err {
                print("error getting documents: \(err)")
            } else {
                
                var count = querySnapshot!.documents.count
                
                while (count > 0) {
                    
                    var timer = 1
                    var highest = 0
                    var user = ""
                    var exists = false
                    
                    for document in querySnapshot!.documents {
                        
                        let level = document.data()["level"] as? Int ?? 1
                        let name = document.data()["name"] as? String ?? ""

                        if level > highest {
                            print("found new highest: \(name)")
                            for string in self.ranks {
                                if name == string {
                                    print("name already exists in ranks")
                                    exists = true
                                }
                            }
                            
                            if (!exists) {
                                print("setting timer to 0")
                                highest = level
                                user = name
                                timer = 0
                            }
                            
                        }

                    }

                    if timer == 0 && self.ranks.count < 10 {
                        self.ranks.append(user)
                        print("appended user: \(user)")
                        count -= 1
                        timer = 1
                    }
                    
                }
                
//                for document in querySnapshot!.documents {
//
//                    let level = document.data()["level"] as? Int ?? 1
//                    let name = document.data()["name"] as? String ?? ""
//
//                    if level > highest {
//                        for string in self.ranks {
//                            if name == string {
//                                print("name already exists in ranks")
//                            } else {
//                                highest = level
//                                user = name
//                            }
//                        }
//                    }
//
//                }
//
//                self.ranks.append(user)
//                count -= 1
                
                completion()
            }
        }
    }

}

extension LeaderboardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Leaderboard
//        print("Reloading data")
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        
        let db = Firestore.firestore()
        
        if indexPath.row < ranks.count {
            let doc = ranks[indexPath.row]
            print("index: \(indexPath.row)")
            print("doc: \(doc)")
            
            db.collection("Leaderboards").document(doc).getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    let level = dataDescription["level"] as! Int

                    cell.nameLabel.text = dataDescription["name"] as? String ?? "Guest"
                    cell.levelLabel.text = "\(dataDescription["level"] ?? 0)"
                }
            }
        }
        
        return cell
    }
    
    
    
    
}
