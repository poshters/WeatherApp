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
    @objc dynamic var cod: String = ""
    @objc dynamic var message: Double = 0.0
    @objc dynamic var cnt: Int = 0
    var list = List<ListH>()
    @objc dynamic var city: City?
    
    override static func primaryKey() -> String? {
        return ModelConstant.weatherForecastPrimaryKey
    }
    
    enum CodingKeys: String, CodingKey {
        case cod
        case message
        case cnt
        case list
        case city
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cod = try container.decode(String.self, forKey: .cod)
        message = try container.decode(Double.self, forKey: .message)
        cnt = try container.decode(Int.self, forKey: .cnt)
        city = try container.decode(City.self, forKey: .city)
        list.append(objectsIn: (try container.decode([ListH].self, forKey: .list)))
    }
}
