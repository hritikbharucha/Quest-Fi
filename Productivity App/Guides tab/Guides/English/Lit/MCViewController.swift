//
//  MCViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 3/27/21.
//

import UIKit

class MCViewController: UIViewController {

    @IBOutlet weak var stepsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stepsLabel.numberOfLines = 0
        stepsLabel.attributedText = bulletPointList(strings: ["Understand word choice, comparisions, and figurative language", "Understand theme of passage", "Paraphrase given lines of a passage", "Explain function of narrator, characters, plot, symbols, and parts of speech"])
    }
    
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        let stringAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 25),
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
