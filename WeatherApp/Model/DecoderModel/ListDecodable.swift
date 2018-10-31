//
//  ListDecodable.swift
//  WeatherApp
//
//  Created by MacBook on 10/30/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

final class ListDecodable: Decodable {
    var dataWeather: Int = 0
    var temp: TempDecodable?
    var pressure: Double = 0.0
    var humidity: Int = 0
    var weather: [WeatherDecodable]?
    var speed: Double = 0.0
    var deg: Int = 0
    
    enum CodingKeys: String, CodingKey {
        
        case dataWeather = "dt"
        case temp
        case pressure
        case humidity
        case weather
        case speed
        case deg
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dataWeather = try values.decode(Int.self, forKey: .dataWeather)
        temp = try values.decode(TempDecodable.self, forKey: .temp)
        pressure = try values.decode(Double.self, forKey: .pressure)
        humidity = try values.decode(Int.self, forKey: .humidity)
        weather = try values.decode([WeatherDecodable].self, forKey: .weather)
        speed = try values.decode(Double.self, forKey: .speed)
        deg = try values.decode(Int.self, forKey: .deg)
    }
}
