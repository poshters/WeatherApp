//
//  HeaderView.swift
//  WeatherApp
//
//  Created by mac on 9/24/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

final class HeaderView: UIView {
    ///UI
    @IBOutlet private weak var iconWeathr: UIImageView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var city: UILabel!
    @IBOutlet private weak var dayOfWeek: UILabel!
    @IBOutlet private weak var temerature: UILabel!
    @IBOutlet private weak var desc: UILabel!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tempHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(HeaderView.className, owner: self, options: nil)
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
    }
    
    ///AccessToOutlet
    func accessToOutlet(city: String, dayOfweeK: String, temperature: String, desc: String, icon: String) {
        self.city.text = city
        self.dayOfWeek.text = dayOfweeK
        self.temerature.text = temperature
        self.desc.text = desc
        self.iconWeathr.image = UIImage(named: icon)
    }
    
    func changeConstraints(top: CGFloat, right: CGFloat, font: CGFloat) {
        topConstraint.constant = top
        rightConstraint.constant = right
        temerature.font = temerature.font.withSize(font)
    }
    
    ///AlphaImage
    func alphaImage(alpha: CGFloat ) {
        self.iconWeathr.alpha = alpha
    }
    
    /// PositionTemerature
    func position() {
        self.temerature.transform =
            CGAffineTransform.identity.translatedBy(x: 115, y: 78).scaledBy(x: 0.38, y: 0.38)
    }
    
    ///DefoultPositionTemerature
    func defoultPosition() {
        self.temerature.transform = CGAffineTransform.identity
    }
}
