//
//  OpenChestViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 6/30/21.
//

import UIKit

class OpenChestViewController: UIViewController {
    
    @IBOutlet weak var xBtn: UIButton!
    
    @IBOutlet weak var rewardImage: UIImageView!
    
    static var imageName = "hair1"
    
    static var bgColor = UIColor.systemGray3
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        xBtn.layer.cornerRadius = xBtn.frame.size.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = Self.bgColor
        rewardImage.image = UIImage(named: Self.imageName)
    }

    @IBAction func xPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
