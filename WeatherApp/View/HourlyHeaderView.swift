//
//  HourlyHeaderView.swift
//  WeatherApp
//
//  Created by mac on 10/2/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import AVFoundation

class HourlyHeaderView: UIView {
    
    ///instance
    let headerLayer = CAShapeLayer()
    private let path = UIBezierPath()
    private var avPlayer = AVPlayer()
    private var avPlayerLayer = AVPlayerLayer()
    private var paused: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        drawHeader()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(HourlyHeaderView.className, owner: self, options: nil)
        self.backgroundColor = UIColor.clear
    }
    
    func drawHeader() {
        let start: CGPoint = CGPoint(x: 0, y: self.bounds.height - 10  )
        let finished: CGPoint = CGPoint(x: self.bounds.width, y: self.bounds.height / 1.2 )
        let controlPoint1 = CGPoint(x: self.bounds.width / 2, y: start.y + 20)
        let controlPoint2 = CGPoint(x: self.bounds.width / 2, y: start.y + -50)
        let line1 = CGPoint(x: self.bounds.width, y: self.bounds.height)
        let line2 = CGPoint(x: 0, y: self.bounds.height)
        path.move(to: start)
        path.addCurve(to: finished,
                      controlPoint1: controlPoint1,
                      controlPoint2: controlPoint2)
        path.addLine(to: line1)
        path.addLine(to: line2)
        path.close()
        headerLayer.path = path.cgPath
        headerLayer.fillColor = UIColor.white.cgColor
        self.layer.insertSublayer(headerLayer, at: 0)
    }
}
