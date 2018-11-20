import Foundation
import RealmSwift
import Realm

final class Weather: Object, Decodable {
    @objc dynamic var desc: String = DefoultConstant.empty
    @objc dynamic var icon: String = DefoultConstant.empty
    @objc dynamic var dateWeather: Int = 0
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var speed: Double = 0.0
    @objc dynamic var deg: Double = 0.0
    @objc dynamic var min: Double = 0.0
    @objc dynamic var max: Double = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case dateWeather = "dt"
        case temp
        case pressure
        case humidity
        case weather
        case speed
        case deg
        case clouds
        case desc
    }
    
    override static func primaryKey() -> String? {
        return ModelConstant.weatherPrimaryKey
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    convenience init (desc: String, icon: String, dateWeather: Int, pressure: Double,
                      humidity: Int, speed: Double, deg: Double, min: Double, max: Double) {
        self.init()
        self.desc = desc
        self.icon = icon
        self.dateWeather = dateWeather
        self.pressure = pressure
        self.humidity = humidity
        self.speed = speed
        self.deg = deg
        self.min = min
        self.max = max
    }
    
    convenience required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dateWeather = try values.decode(Int.self, forKey: .dateWeather)
        let temp = try values.decode(TempHourly.self, forKey: .temp)
        let min = temp.min
        let max = temp.max
        let pressure = try values.decode(Double.self, forKey: .pressure)
        let humidity = try values.decode(Int.self, forKey: .humidity)
        let temporary = try values.decode([Temporary].self, forKey: .weather)
        let desc = temporary[0].desc
        let icon = temporary[0].icon
        let speed = try values.decode(Double.self, forKey: .speed)
        let deg = try values.decode(Double.self, forKey: .deg)
        
        self.init( desc: desc, icon: icon, dateWeather: dateWeather, pressure: pressure,
                   humidity: humidity, speed: speed, deg: deg, min: min, max: max)
    }
    
    required init() {
        super.init()
    }
}

final class Temporary: Decodable {
    @objc dynamic var desc: String = DefoultConstant.empty
    @objc dynamic var icon: String = DefoultConstant.empty
    
    private enum CodingKeys: String, CodingKey {
        case desc = "description"
        case icon
    }
}

final class TempHourly: Decodable {
    @objc dynamic var min: Double = 0.0
    @objc dynamic var max: Double = 0.0
}
