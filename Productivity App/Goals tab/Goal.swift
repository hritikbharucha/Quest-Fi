//
//  Goal.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/23/21.
//

import UIKit

class Goal: UITableViewCell {
    
    @IBOutlet weak var goalContainerView: UIView!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var progressButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addShadowAndRoundCorners(goalContainerView)
        progressButton.isHidden = true
        completeButton.isHidden = true
        completeButton.layer.cornerRadius = 15
        completeButton.clipsToBounds = true
        completeButton.layer.borderWidth = 2
        completeButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.backgroundColor = .clear
        self.goalContainerView.backgroundColor = .clear
        self.taskLabel.text = .none
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
