//import Foundation
//import CoreLocation
//
//final class ApiWeather {
//    private let lat = UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude)
//    private let long = UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude)
//    private let language = Locale.current.languageCode ?? DefoultConstant.empty
//
//    func getWeatherForecastByCity(lat: Double, long: Double, completion: ((WeatherForecast?, Error?) -> Void)? = nil) {
//        let session = URLSession.shared
//        guard let weatherRequestURL = URL(string: urlApiOpenWeather(url: ApiWeatherConstant.openWeatherMapBaseURL,
//                                                                    language: language,
//                                                                    apiKey: ApiWeatherConstant.openWeatherMapAPIKey,
//                                                                    lat: lat,
//                                                                    lon: long)) else {
//                                                                        completion?(nil, nil)
//                                                                        return
//        }
//        session.dataTask(with: weatherRequestURL) { (data, response, error) in
//            guard let data = data else {
//                completion?(nil, nil)
//                return
//
//            }
//            guard error == nil else {
//                completion?(nil, error)
//                return
//            }
//
//            let jsonDecoder = JSONDecoder()
//            do {
//                let responseModel = try jsonDecoder.decode(WeatherForecast.self, from: data)
//                completion?(responseModel, nil)
//            } catch let error {
//                completion?(nil, error)
//                print(error)
//            }
//            }
//            .resume()
//    }
//
//    /// URl OpenWeatherMap
//    private func urlApiOpenWeather(url: String, language: String, apiKey: String, lat: Double, lon: Double) -> String {
//        return "\(url)lat=\(lat)&lon=\(lon)&cnt=14&lang=\(language)&APPID=\(apiKey)"
//    }
//}
