//
//  ViewWithDiagonalLine.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 9/10/21.
//

import UIKit
import Foundation

class ViewWithDiagonalLine: UIView {

    private var line = UIView()

    private var lengthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() -> Void {
        // Initialize line view
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.red

        clipsToBounds = true // Cut off everything outside the view

        // Add and layout the line view

        addSubview(line)

        // Define line width
        line.addConstraint(NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2.5))

        // Set up line length constraint
        lengthConstraint = NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        addConstraint(lengthConstraint)

        // Center line in view
        addConstraint(NSLayoutConstraint(item: line, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: line, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update length constraint and rotation angle
        lengthConstraint.constant = sqrt(pow(frame.size.width, 2) + pow(frame.size.height, 2))
        line.transform = CGAffineTransform(rotationAngle: atan2(frame.size.height, frame.size.width))
    }

}
