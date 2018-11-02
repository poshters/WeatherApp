//
//  MapPinView.swift
//  WeatherApp
//
//  Created by MacBook on 10/31/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

final class MapPinView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriprionLabel: UILabel!
    
    let headerLayer = CAShapeLayer()
    private let path = UIBezierPath()
    
    func accessToOutlet(temperature: String, city: String, description: String, icon: String) {
        temperatureLabel.text = temperature
        cityLabel.text = city
        descriprionLabel.text = description
        imageView.image = UIImage(named: icon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    }
    
    override func draw(_ rect: CGRect) {
        drawHeader()
    }
    
    /// drawHeaderUIBezierPath
    private func drawHeader() {
        let start: CGPoint = CGPoint(x: 20, y: 0)
        let line1 = CGPoint(x: self.bounds.width - 20, y: 0)
        let line2 = CGPoint(x: self.bounds.width, y: 20)
        let line3 = CGPoint(x: self.bounds.width, y: self.bounds.height - 40)
        let line4 = CGPoint(x: self.bounds.width - 20, y: self.bounds.height - 20)
        let line5 = CGPoint(x: self.bounds.width / 1.8, y: self.bounds.height - 20)
        let line6 = CGPoint(x: self.bounds.width / 2, y: self.bounds.height)
        let line7 = CGPoint(x: self.bounds.width / 2.2, y: self.bounds.height - 20)
        let line8 = CGPoint(x: 20, y: self.bounds.height - 20)
        let line9 = CGPoint(x: 0, y: self.bounds.height - 40)
        let line10 = CGPoint(x: 0, y: 20)
        
        path.move(to: start)
        path.addLine(to: line1)
        path.addLine(to: line2)
        path.addArc(withCenter: CGPoint( x: self.bounds.width - 20, y: 20), radius: 20,
                    startAngle: CGFloat(3 * Double.pi / 2), endAngle: CGFloat(0), clockwise: true)
        path.addLine(to: line3)
        path.addLine(to: line4)
        path.addLine(to: line5)
        path.addLine(to: line6)
        path.addLine(to: line7)
        path.addArc(withCenter: CGPoint(x: self.bounds.width - 20, y: self.bounds.height - 40), radius: 20,
                    startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        path.addLine(to: line8)
        path.addLine(to: line9)
        path.addArc(withCenter: CGPoint(x: 20, y: self.bounds.height - 40), radius: 20,
                    startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        path.addLine(to: line10)
        path.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                    startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
        path.close()
        headerLayer.path = path.cgPath
        layer.mask = headerLayer
    }
}
