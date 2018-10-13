import Foundation
import RealmSwift

final class City: Object, Decodable {
    @objc dynamic var name: String = DefoultConstant.empty
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case name
        case coord
    }
    
    override static func primaryKey() -> String? {
        return ModelConstant.cityPrimaryKey
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        let coord = try values.decode(Coord.self, forKey: .coord)
        lat = coord.lat
        lon = coord.lon
        
    }
}

final class Coord: Decodable {
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decode(Double.self, forKey: .lat)
        lon = try values.decode(Double.self, forKey: .lon)
        
    }
}
