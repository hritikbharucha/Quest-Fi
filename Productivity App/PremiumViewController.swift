//
//  PremiumViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/12/21.
//

import UIKit

class PremiumViewController: UIViewController {

    @IBOutlet weak var listLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listLabel.numberOfLines = 0
        listLabel.attributedText =  bulletPointList(strings: ["Unlock all study guides", "500 free goal points every month", "1 free magical chest every month", "Get exclusive monthly item"])
    }
    
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 30),
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ] as [NSAttributedString.Key : Any]

        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n\n")

        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }

}
