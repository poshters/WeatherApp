//
//  MainHorly.swift
//  WeatherApp
//
//  Created by MacBook on 10/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RealmSwift

final class MainHourly: Object, Decodable {
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var tempMin: Double = 0.0
    @objc dynamic var tempMax: Double = 0.0
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var seaLevel: Double = 0.0
    @objc dynamic var grndLevel: Double = 0.0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var tempKf: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Double.self, forKey: .temp)
        tempMin = try container.decode(Double.self, forKey: .tempMin)
        tempMax = try container.decode(Double.self, forKey: .tempMax)
        pressure = try container.decode(Double.self, forKey: .pressure)
        seaLevel = try container.decode(Double.self, forKey: .seaLevel)
        grndLevel = try container.decode(Double.self, forKey: .grndLevel)
        humidity = try container.decode(Int.self, forKey: .humidity)
        tempKf = try container.decode(Double.self, forKey: .tempKf)
    }
}
