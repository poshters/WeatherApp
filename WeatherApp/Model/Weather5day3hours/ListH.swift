//
//  ListH.swift
//  WeatherApp
//
//  Created by MacBook on 10/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RealmSwift

final class ListH: Object, Decodable {
    @objc dynamic var dateWeather: Int = 0
    @objc dynamic var main: MainHourly?
    var weather = List<WeatherH>()
    
    enum CodingKeys: String, CodingKey {
        case dateWeather = "dt"
        case main
        case weather
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self )
        dateWeather = try container.decode(Int.self, forKey: .dateWeather )
        main = try container.decode(MainHourly.self, forKey: .main)
        weather.append(objectsIn: (try? container.decode([WeatherH].self, forKey: .weather)) ?? [])
    }
}
