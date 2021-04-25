//
//  PorParaViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 3/30/21.
//

import UIKit

class PorParaViewController: UIViewController {
    
    @IBOutlet weak var paraLabel: UILabel!
    @IBOutlet weak var porLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        porLabel.numberOfLines = 0
        paraLabel.numberOfLines = 0
        
        porLabel.attributedText = bulletPointList(strings: ["Travel And communication - mode of travel, form of communication, or route of travel", "Exchanges and trades", "Duration of an activity", "Motivation for doing something"])
        paraLabel.attributedText = bulletPointList(strings: ["Destination of trip", "Recipient of gift or something", "Deadline of assignment or work", "Goals and purposes - why something is done"])
    }
    
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 20),
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ] as [NSAttributedString.Key : Any]

        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n\n")

        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }

}
