//
//  TipsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit

class TipsViewController: UIViewController {
    
    @IBOutlet weak var labelWithWords: UILabel!
    
    @IBOutlet weak var tipsButton: UIButton!
    
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var tipsView: UIView!
    
    var viewWidth : CGFloat = 414
    var viewHeight : CGFloat = 896
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        
    }
    
    override func viewDidLayoutSubviews() {
        makeButtonGood(tipsButton, tipsView)
        makeButtonGood(timerButton, timerView)
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
    
}
