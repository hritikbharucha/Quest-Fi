//
//  GuidesViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/15/21.
//

import UIKit

class GuidesViewController: UIViewController {

    @IBOutlet weak var mathBackView: UIView!
    
    @IBOutlet weak var mathFrontView: UIView!
    
    @IBOutlet weak var englishBackView: UIView!
    
    @IBOutlet weak var englishFrontView: UIView!
    
    @IBOutlet weak var spanishBackView: UIView!
    
    @IBOutlet weak var spanishFrontView: UIView!
    
    @IBOutlet weak var historyBackView: UIView!
    
    @IBOutlet weak var historyFrontView: UIView!
    
    @IBOutlet weak var scienceBackView: UIView!
    
    @IBOutlet weak var scienceFrontView: UIView!
    
    @IBOutlet weak var csBackView: UIView!
    
    @IBOutlet weak var csFrontView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeViewnGood(mathFrontView, mathBackView)
        makeViewnGood(englishFrontView, englishBackView)
        makeViewnGood(spanishFrontView, spanishBackView)
        makeViewnGood(historyFrontView, historyBackView)
        makeViewnGood(scienceFrontView, scienceBackView)
        makeViewnGood(csFrontView, csBackView)
        
    }
    
    func makeViewnGood(_ view: UIView, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 20).cgPath
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        
    }

}
