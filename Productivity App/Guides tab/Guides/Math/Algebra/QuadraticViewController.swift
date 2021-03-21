//
//  QuadraticViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 3/17/21.
//

import UIKit

class QuadraticViewController: UIViewController {
    
    @IBOutlet weak var standardFormLabel: UILabel!
    
    @IBOutlet weak var factoredFormLabel: UILabel!
    
    @IBOutlet weak var pointFormLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelWithExponent(standardFormLabel, "y = ax2 + bx + c", 6)
        labelWithExponent(pointFormLabel, "y = a(x + b)2 + c", 12)
    }
    
    func labelWithExponent(_ label: UILabel, _ text: String, _ location: Int) {
        
        let font:UIFont? = UIFont(name: "DIN Alternate", size:20)
        let fontSuper:UIFont? = UIFont(name: "DIN Alternate", size:13)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location: location,length: 1))
        label.attributedText = attString
        
    }

}
