//
//  WeatherDecodable.swift
//  WeatherApp
//
//  Created by MacBook on 10/30/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

final class WeatherDecodable: Decodable {
    var descriptionCD: String = ""
    var icon: String = ""
    
    enum CodingKeys: String, CodingKey {
        
        case descriptionCD = "description"
        case icon
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        descriptionCD = try values.decode(String.self, forKey: .descriptionCD)
        icon = try values.decode(String.self, forKey: .icon)
    }
}
