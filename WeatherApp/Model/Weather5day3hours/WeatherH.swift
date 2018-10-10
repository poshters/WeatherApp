//
//  WeatherH.swift
//  WeatherApp
//
//  Created by MacBook on 10/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RealmSwift

final class WeatherH: Object, Decodable {
    
    @objc dynamic var desc: String = ""
    @objc dynamic var icon: String = ""
    @objc dynamic var realmId = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return ModelConstant.weatherForecastPrimaryKey
    }
    
    enum CodingKeys: String, CodingKey {
        case desc = "description"
        case icon
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        desc = try container.decode(String.self, forKey: .desc)
        icon = try container.decode(String.self, forKey: .icon)
    }
}
