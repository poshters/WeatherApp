import Foundation
import RealmSwift

class DBManager {
    class func getAllCities() -> Results<City>? {
        do {
            let realm = try Realm()
            let result = realm.objects(City.self)
            return result
        } catch {
            return nil
        }
    }
    
    class func getWeatherForCityToday(city: City) -> Weather? {
        do {
            let realm = try Realm()
            let weather =
                realm.objects(Weather.self).filter(
                    DBManagerConstant.cityNameFilter, city.name).sorted(byKeyPath: ModelConstant.weatherPrimaryKey,
                                                                        ascending: true).first
            return weather
        } catch {
            return nil
        }
    }
    
    @discardableResult
    class func addDB(object: WeatherForecast) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(WeatherForecast.self).filter(
                    "city.name = %@", object.city?.name ?? DefoultConstant.empty))
                realm.add(object, update: true)
            }
            return true
        } catch {
            return false
        }
    }
    
    class func  getWeatherForecastByCity(city: City) -> WeatherForecast? {
        do {
            let realm = try Realm()
            let result = realm.objects(WeatherForecast.self).filter("city.name = %@", city.name ).first
            return result
            
        } catch {
            return nil
        }
    }
    class func addDBHourly(object: WeatherHourly) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(WeatherForecast.self).filter(
                    "city.name = %@", object.city?.name ?? DefoultConstant.empty))
                realm.add(object, update: true)
            }
            return true
        } catch {
            return false
        }
    }
}
