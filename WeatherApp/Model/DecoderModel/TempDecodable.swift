//
//  TempDecodable.swift
//  WeatherApp
//
//  Created by MacBook on 10/30/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

final class TempDecodable: Codable {
    var min: Double = 0.0
    var max: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        
        case min
        case max
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        min = try values.decode(Double.self, forKey: .min)
        max = try values.decode(Double.self, forKey: .max)

    }
}
