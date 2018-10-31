//
//  CoordDecodable.swift
//  WeatherApp
//
//  Created by MacBook on 10/30/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
final class CoordDecodable: Decodable {
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decode(Double.self, forKey: .lat)
        lon = try values.decode(Double.self, forKey: .lon)
    }
}
