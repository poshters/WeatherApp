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
    @IBOutlet private weak var hourlyDescriptionLabel: UILabel!
    @IBOutlet private weak var humiudityIconImage: UIImageView!
    @IBOutlet private weak var hourlyPressureLabel: UILabel!
    @IBOutlet private weak var hourlyHumidityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func accessToOutlet(dayOfweek: String, temp: String, description: String,
                        pressure: String, humidity: String) {
        hourlyLabel.text = dayOfweek
        tempLabel.text = temp
        hourlyDescriptionLabel.text = description
        hourlyPressureLabel.text = pressure
        hourlyHumidityLabel.text = humidity
    }
    func accessToImage(icon: String) {
        humiudityIconImage.image = UIImage(named: icon)
    }
    
}
