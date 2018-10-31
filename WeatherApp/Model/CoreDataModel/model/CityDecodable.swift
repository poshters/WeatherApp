import Foundation

class CityDecodable: Decodable {
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
