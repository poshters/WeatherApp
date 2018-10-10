//
//  CustomButton.swift
//  WeatherApp
//
//  Created by mac on 10/4/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

 let header = HourlyHeaderView()
 
    override func layoutSubviews() {
        updateLayerProperties()
        super.layoutSubviews()
//        self.frame = CGRect(x: UIScreen.main.bounds.width / 2, y: header.bounds.height / 1.2,
//                            width: 80, height: 80)
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
