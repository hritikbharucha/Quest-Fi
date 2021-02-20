//
//  HomeViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logButton: UIButton!
    
    @IBOutlet weak var logView: UIView!
    
    @IBOutlet weak var leaderboardsButton: UIButton!
    
    @IBOutlet weak var leaderBoardsView: UIView!
    
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var userButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonGood(leaderboardsButton, leaderBoardsView)
        makeButtonGood(userButton, userView)
        makeButtonGood(logButton, logView)
        
        userButton.layer.cornerRadius = 30
        userView.layer.cornerRadius = 30
        
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
    
    @IBAction func logPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToCalendar", sender: self)
    }
    
}
