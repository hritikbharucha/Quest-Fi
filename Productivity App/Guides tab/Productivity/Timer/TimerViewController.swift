//
//  TimerViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var startView: UIView!
    
    var viewWidth : CGFloat = 414
    var viewHeight : CGFloat = 896
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width

    }
    
    override func viewDidLayoutSubviews() {
        makeButtonGood(startButton, startView)
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
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "timerToTimerSettings", sender: self)
    }
    @IBAction func startPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "timerToActualTimer", sender: self)
    }
}
