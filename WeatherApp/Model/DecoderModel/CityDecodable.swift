//
//  CityDecodable.swift
//  WeatherApp
//
//  Created by MacBook on 10/30/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

final class CityDecodable: Decodable {
    var name: String = ""
    var coord: CoordDecodable?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coord
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        coord = try values.decode(CoordDecodable?.self, forKey: .coord)
    }
}
