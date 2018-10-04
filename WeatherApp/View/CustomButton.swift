//
//  CustomButton.swift
//  WeatherApp
//
//  Created by mac on 10/4/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

 
    
    override func layoutSubviews() {
        updateLayerProperties()
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * self.bounds.size.height
        clipsToBounds = false

    }
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = true
    }
}
