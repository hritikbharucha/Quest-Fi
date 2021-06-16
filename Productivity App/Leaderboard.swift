//
//  Leaderboard.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 6/10/21.
//

import UIKit

class Leaderboard: UITableViewCell {
    
    @IBOutlet weak var leaderboardContainerView: UIView!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func addShadowAndRoundCorners(_ shadowView: UIView) {
        shadowView.backgroundColor = UIColor(red:228.0/255.0, green:228.0/255.0, blue:228.0/255.0, alpha:0.5)
        shadowView.layer.cornerRadius = 5.0
        shadowView.layer.borderColor = UIColor.lightGray.cgColor
        shadowView.layer.borderWidth = 0.2
        shadowView.layer.shadowColor = UIColor(red:225.0/255.0, green:228.0/255.0, blue:228.0/255.0, alpha:1.0).cgColor
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
}
