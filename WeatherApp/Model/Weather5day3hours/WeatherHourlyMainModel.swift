//
//  modelTest.swift
//  WeatherApp
//
//  Created by mac on 10/4/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RealmSwift

final class WeatherHourlyMainModel: Object, Decodable {
    @objc dynamic var realmId = UUID().uuidString
    var list = List<ListH>()
    @objc dynamic var city: City?
    
    override static func primaryKey() -> String? {
        return ModelConstant.weatherForecastPrimaryKey
    }
    
    enum CodingKeys: String, CodingKey {
        case list
        case city
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(City.self, forKey: .city)
        list.append(objectsIn: (try container.decode([ListH].self, forKey: .list)))
    }
}
