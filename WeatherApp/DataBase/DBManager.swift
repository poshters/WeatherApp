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
                    DBManagerConstant.cityNameFilter, object.city?.name ?? DefoultConstant.empty))
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
            let result = realm.objects(WeatherForecast.self).filter(DBManagerConstant.cityNameFilter, city.name ).first
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
                    DBManagerConstant.cityNameFilter, city.name)
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
        }
    }
    
    class func  getWeatherForecastByCity(city: City, date: Int) -> List<ListH>? {
        do {
            let realm = try Realm()
            var dateCalendar = Date(timeIntervalSince1970: (TimeInterval(date * 1000)))
            
            var calendar = Calendar.current
            let firstDate = calendar.startOfDay(for: dateCalendar)
            let secondDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: dateCalendar)
            
            func currentTimeInMiliseconds(date: Date) -> Int {
                let since1970 = date.timeIntervalSince1970
                return Int(since1970 / 1000)
            }
            
            let first = currentTimeInMiliseconds(date: firstDate)
            let second = currentTimeInMiliseconds(date: secondDate ?? Date())
            
//            let result = realm.objects(List<ListH>).filter("city.name == %@", city.name,
//                                                     "ListH.dataWeather = %@", date).first
            
            return result
            
        } catch {
            return nil
        }
    }
}

