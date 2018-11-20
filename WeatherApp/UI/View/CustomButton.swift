//
//  CustomButton.swift
//  WeatherApp
//
//  Created by mac on 10/4/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

final class CustomButton: UIButton {
    // MARK: - Instance
   private let header = HourlyHeaderView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerProperties()
        layer.cornerRadius = 0.5 * self.bounds.size.height
        clipsToBounds = false
    }
    
   /// Update layer properties
   private func updateLayerProperties() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = true
    }
}
