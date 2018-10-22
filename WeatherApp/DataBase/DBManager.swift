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
                    DBManagerConstant.cityNameFilter, object.city?.lon ?? DefoultConstant.empty,
                    object.city?.lat ?? DefoultConstant.empty))
                realm.add(object, update: true)
            }
            return true
        } catch {
            return false
        }
    }
    
    class func  getWeatherForecastByCity(lat: Double, long: Double) -> Results<WeatherForecast>? {
        do {
            let realm = try Realm()
            let result = realm.objects(WeatherForecast.self).filter(DBManagerConstant.cityNameFilter, long, lat)
            return result
            
        } catch {
            return nil
        }
    }
    @discardableResult
    class func addDBHourly(object: WeatherHourlyMainModel) -> Bool {
        do {
            let realm = try Realm()
            deleteHourlyWeather(city: object.city ?? City())
            try realm.write {
                realm.add(object, update: true)
            }
            return true
        } catch {
            return false
        }
    }
    
    class func deleteHourlyWeather(city: City) {
        do {
            let realm = try Realm()
            try realm.write {
                let weatherHourlyList = realm.objects(WeatherHourlyMainModel.self).filter(
                    DBManagerConstant.cityNameFilter, city.lon, city.lat)
                for weatherHourly in weatherHourlyList {
                    for listH in weatherHourly.list {
                        realm.delete(listH.main ?? MainHourly())
                        realm.delete(listH.weather)
                        realm.delete(listH)
                    }
                    realm.delete(weatherHourly)
                }
                realm.delete(weatherHourlyList)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func  getWeatherForecastByCity(lat: Double, long: Double, date: Int) -> [ListH]? {
        do {
            let realm = try Realm()
            var dateCalendar = Date(timeIntervalSince1970: (TimeInterval(date)))
            
            var calendar = Calendar.current
            let firstDate = calendar.startOfDay(for: dateCalendar)
            let secondDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: dateCalendar)
            
            func currentTimeInMiliseconds(date: Date) -> Int {
                let since1970 = date.timeIntervalSince1970
                return Int(since1970)
            }
            
            let first = currentTimeInMiliseconds(date: firstDate)
            let second = currentTimeInMiliseconds(date: secondDate ?? Date())
            let result = realm.objects(WeatherHourlyMainModel.self).filter(DBManagerConstant.cityNameFilter,
                                                                           long, lat).first
            var list = [ListH]()
            for weatherHourly in (result?.list) ?? List<ListH>() {
                if weatherHourly.dateWeather > first && weatherHourly.dateWeather < second {
                    list.append(weatherHourly)
                }
            }
            print(list)
            return list
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getWeatherForecastByCity(city: City?, completion: ((WeatherForecast?, Error?) -> Void)? = nil) {
        guard let city = city else {
            completion?(nil, nil)
            return
        }
        do {
            let realm = try Realm()
            let result = realm.objects(WeatherForecast.self).filter(DBManagerConstant.cityNameFilter, city.name).first
            
            completion?(result, nil)
            
        } catch {
            completion?(nil, nil)
        }
    }
}
