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

        makeViewGood(mathFrontView, mathBackView)
        makeViewGood(englishFrontView, englishBackView)
        makeViewGood(spanishFrontView, spanishBackView)
        makeViewGood(historyFrontView, historyBackView)
        makeViewGood(scienceFrontView, scienceBackView)
        makeViewGood(csFrontView, csBackView)
        
    }
    
    func makeViewGood(_ view: UIView, _ containerView: UIView) {
        
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
    
    @IBAction func mathPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "guidesToMath", sender: self)
    }
    
    @IBAction func englishPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "guidesToEnglish", sender: self)
    }
    
    @IBAction func spanishPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "guidesToSpanish", sender: self)
    }
    
    @IBAction func historyPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "guidesToHistory", sender: self)
    }
    
    @IBAction func sciencePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "guidesToScience", sender: self)
    }
    
    @IBAction func csPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "guidesToCS", sender: self)
    }
    

}
