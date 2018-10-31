//
//  WeatherForecastDecodable.swift
//  WeatherApp
//
//  Created by MacBook on 10/30/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

final class WeatherForecastDecodable: Decodable {
    var city: CityDecodable?
    var list: [ListDecodable]?
    
    enum CodingKeys: String, CodingKey {
        
        case city
        case list
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decode(CityDecodable.self, forKey: .city)
        list = try values.decode([ListDecodable].self, forKey: .list)
    }
}
