//
//  ExponentialViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 3/17/21.
//

import UIKit

class ExponentialViewController: UIViewController {

    @IBOutlet weak var formLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelWithExponent(formLabel, "y = abx", 6)
    }
    
    func labelWithExponent(_ label: UILabel, _ text: String, _ location: Int) {
        
        let font:UIFont? = UIFont(name: "DIN Alternate", size:20)
        let fontSuper:UIFont? = UIFont(name: "DIN Alternate", size:15)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location: location,length: 1))
        label.attributedText = attString
        
    }

}
