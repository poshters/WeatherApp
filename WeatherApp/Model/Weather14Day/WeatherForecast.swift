import Foundation
import RealmSwift
import Realm

final class WeatherForecast: Object, Decodable {
    @objc dynamic var realmId = UUID().uuidString
    @objc dynamic var city: City?
    var list = List<Weather>()
    
    override static func primaryKey() -> String? {
        return ModelConstant.weatherForecastPrimaryKey
    }
    
    private enum CodingKeys: String, CodingKey {
        case city
        case list
    }
    
    convenience init(city: City, list: List<Weather>) {
        self.init()
        self.city = city
        self.list = list
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let city = try container.decode(City.self, forKey: .city)
        let listArray = try container.decode([Weather].self, forKey: .list)
        let listTemp = List<Weather>()
        listTemp.append(objectsIn: listArray)
        self.init(city: city, list: listTemp)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
