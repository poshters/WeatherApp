//
//  ChekBox.swift
//  
//
//  Created by MacBook on 11/11/18.
//

import UIKit

class ChekBoxButton: UIButton {
    
    // MARK: - Instance
    private var line = UIBezierPath()
    private var cycle = UIBezierPath()
    private let shapeLayerCycle = CAShapeLayer()
    private let shapeLayerLine = CAShapeLayer()
    private let maskLayer = CAShapeLayer()
    
    var isChecked: Bool = false
    var isDisable: Bool = false
    var isClicked: Bool = false {
        didSet {
            if isClicked == true {
                clickOn()
            }
        }
    }
    
    // MARK: - UI
    @IBInspectable var colorCycle: UIColor = UIColor.lightGray
    @IBInspectable var colorMask: UIColor = UIColor.green
    @IBInspectable var colorLine: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
    }
}

// MARK: - Actions
extension ChekBoxButton {
    @objc func buttonDisable(sender: UIButton) {
        if sender == self {
            isDisable = !isDisable
        }
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
    /// Draw button
    @objc func drawButton() {
        // lineParameters
        let start = CGPoint(x: self.frame.size.width / 6, y: self.frame.size.height / 2 + 8)
        let line1 = CGPoint(x: self.frame.size.width / 10, y: self.frame.size.height / 2.2)
        let line2 = CGPoint(x: self.frame.size.width / 4, y: self.frame.size.height / 2 - 14)
        
        // Cycle
        self.cycle = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 6,
                                                     y: self.frame.size.height / 2),
                                  radius: 30,
                                  startAngle: CGFloat(Double.pi * 3) / 1.7,
                                  endAngle: CGFloat(Double.pi * 3) / 1.701,
                                  clockwise: true)
        cycle.lineCapStyle = .round
        shapeLayerCycle.path = self.cycle.cgPath
        shapeLayerCycle.strokeColor = colorCycle.cgColor
        shapeLayerCycle.lineWidth = 5
        shapeLayerCycle.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayerCycle)
        
        maskLayer.path = self.cycle.cgPath
        maskLayer.strokeColor = UIColor.clear.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 5
        self.layer.addSublayer(maskLayer)
        
        // Line
        line.move(to: line1)
        line.addLine(to: start)
        line.move(to: start)
        line.addLine(to: line2)
        line.lineCapStyle = .round
        shapeLayerLine.lineCap = CAShapeLayerLineCap.round
        shapeLayerLine.path = self.line.cgPath
        shapeLayerLine.lineWidth = 5
        shapeLayerLine.strokeColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayerLine)
        
    }
    
    /// Сlick on
    @objc func clickOn() {
        // AnimationCycle
        let animationCycle = CABasicAnimation(keyPath: CheckButtonConstants.strokeEnd)
        maskLayer.strokeColor = colorMask.cgColor
        animationCycle.fromValue = 0
        animationCycle.toValue = 1
        animationCycle.duration = 0.5
        maskLayer.add(animationCycle, forKey: CheckButtonConstants.animationCycle)
        
        // AnimationLine
        let animationLine = CABasicAnimation(keyPath: CheckButtonConstants.strokeEnd)
        shapeLayerLine.strokeColor = colorLine.cgColor
        animationLine.fromValue = 0
        animationLine.toValue = 1
        animationLine.duration = 0.5
        shapeLayerLine.add(animationLine, forKey: CheckButtonConstants.animationLine)
    }
    
    /// Сlick off
    @objc func clickOff() {
        // AnimationCycle
        let animationCycle = CABasicAnimation(keyPath: CheckButtonConstants.strokeEnd)
        maskLayer.strokeColor = colorMask.cgColor
        animationCycle.fromValue = 1
        animationCycle.toValue = 0
        animationCycle.duration = 0.5
        animationCycle.fillMode = CAMediaTimingFillMode.forwards
        animationCycle.isRemovedOnCompletion = false
        maskLayer.add(animationCycle, forKey: CheckButtonConstants.animationCycle)
        
        // AnimationLine
        let animationLine = CABasicAnimation(keyPath: CheckButtonConstants.strokeEnd)
        animationLine.fromValue = 1
        animationLine.toValue = -0.01
        animationLine.duration = 0.5
        animationLine.fillMode = CAMediaTimingFillMode.forwards
        animationLine.isRemovedOnCompletion = false
        shapeLayerLine.add(animationLine, forKey: CheckButtonConstants.animationLine)
    }
}
