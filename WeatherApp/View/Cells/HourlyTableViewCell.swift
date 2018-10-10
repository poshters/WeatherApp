//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by MacBook on 10/8/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    ///UI
    @IBOutlet private weak var hourlyicon: UIImageView!
    @IBOutlet private weak var hourlyLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func accessToOutlet(hour: String, temp: String) {
        hourlyLabel.text = hour
        tempLabel.text = temp
    }
    
    func alphaIcon(alpha: CGFloat) {
        hourlyicon.alpha = alpha
    }
}
