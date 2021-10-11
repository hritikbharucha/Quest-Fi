//
//  CircularProgress.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 9/3/21.
//

import UIKit

@IBDesignable
public class CircularProgress: UIView {

    @IBInspectable
    public var lineWidth: CGFloat = 5              { didSet { updatePath() } }

    @IBInspectable
    public var strokeEnd: CGFloat = 1              { didSet { progressLayer.strokeEnd = strokeEnd } }

    @IBInspectable
    public var trackColor: UIColor = .black        { didSet { trackLayer.strokeColor = trackColor.cgColor } }

    @IBInspectable
    public var progressColor: UIColor = .red       { didSet { progressLayer.strokeColor = progressColor.cgColor } }

    @IBInspectable
    public var inset: CGFloat = 0                  { didSet { updatePath() } }

    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = trackColor.cgColor
        layer.lineWidth = lineWidth
        return layer
    }()

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressColor.cgColor
        layer.lineWidth = lineWidth
        return layer
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
}

private extension CircularProgress {
    func setupView() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }

    func updatePath() {
        let rect = bounds.insetBy(dx: lineWidth / 2 + inset, dy: lineWidth / 2 + inset)

        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let path = UIBezierPath(arcCenter: centre,
                                radius: radius,
                                startAngle: -.pi / 2,
                                endAngle: 3 * .pi / 2,
                                clockwise: true)

        trackLayer.path = path.cgPath
        trackLayer.lineWidth = lineWidth

        progressLayer.path = path.cgPath
        progressLayer.lineWidth = lineWidth
    }
}
