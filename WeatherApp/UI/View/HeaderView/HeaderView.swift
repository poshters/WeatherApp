//
//  HeaderView.swift
//  WeatherApp
//
//  Created by mac on 9/24/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

protocol HeaderViewDalegate: class {
    func buttonAction()
    func shareButton()
}

final class HeaderView: UIView {
    // MARK: - UI
    @IBOutlet private weak var iconWeathrImage: UIImageView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tempHeightConstraint: NSLayoutConstraint!
    private var scrollView = UIScrollView()
    
    // MARK: - Instance
    private let mainVC = MainViewController()
    weak var headerDelegate: HeaderViewDalegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Common init
    private func commonInit() {
        Bundle.main.loadNibNamed(HeaderView.className, owner: self, options: nil)
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
    }
    
    /// Access to outlet
    ///
    /// - Parameters:
    ///   - city: String
    ///   - dayOfweeK: String
    ///   - temperature: String
    ///   - desc: String
    ///   - icon: String
    func accessToOutlet(city: String, dayOfweeK: String, temperature: String, desc: String, icon: String) {
        self.cityLabel.text = city
        self.dayOfWeekLabel.text = dayOfweeK
        self.temperatureLabel.text = temperature
        self.descriptionLabel.text = desc
        self.iconWeathrImage.image = UIImage(named: icon)
    }
    
    /// Change constraints
    ///
    /// - Parameters:
    ///   - top: CGFloat
    ///   - right: CGFloat
    ///   - font: CGFloat
    func changeConstraints(top: CGFloat, right: CGFloat, font: CGFloat) {
        topConstraint.constant = top
        rightConstraint.constant = right
        temperatureLabel.font = temperatureLabel.font.withSize(font)
    }
    
    ///Alpha image
    ///
    /// - Parameter alpha: CGFloat
    func alphaImage(alpha: CGFloat ) {
        self.iconWeathrImage.alpha = alpha
    }
    
    /// PositionTemperatureLabel
    func position() {
        self.temperatureLabel.transform =
            CGAffineTransform.identity.translatedBy(x: 115, y: 78).scaledBy(x: 0.38, y: 0.38)
    }
    
    ///DefoultPositionTemperatureLabel
    func defoultPosition() {
        self.temperatureLabel.transform = CGAffineTransform.identity
    }
}

// MARK: - ActionButton
extension HeaderView {
    /// Map button action
    ///
    /// - Parameter sender: Any
    @IBAction func mapButtonAction(_ sender: Any) {
        headerDelegate?.buttonAction()
    }
    
    /// Button sharing
    ///
    /// - Parameter sender: UIButton
    @IBAction func buttonSharing(_ sender: UIButton) {
        headerDelegate?.shareButton()
    }
}
