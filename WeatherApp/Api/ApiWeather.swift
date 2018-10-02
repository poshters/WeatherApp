import Foundation
import CoreLocation

final class ApiWeather {
    private let lat = UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude)
    private let long = UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude)
    private let language = Locale.current.languageCode ?? DefoultConstant.empty
    
    func getWeatherForecastByCity(lat: Double, long: Double) -> WeatherForecast {
        let semaphore = DispatchSemaphore(value: 0)
        var responseModel = WeatherForecast()
        let session = URLSession.shared
        guard let weatherRequestURL = URL(string: urlApiOpenWeather(url: ApiWeatherConstant.openWeatherMapBaseURL,
                                                                    language: language,
                                                                    apiKey: ApiWeatherConstant.openWeatherMapAPIKey,
                                                                    lat: lat,
                                                                    lon: long)) else {
                                                                        return WeatherForecast()
        }
        session.dataTask(with: weatherRequestURL) { (data, response, error) in
            guard response != nil else {
                return
            }
            guard let data = data else {
                return
                
            }
            guard  error == nil else {
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                responseModel = try jsonDecoder.decode(WeatherForecast.self, from: data)
                semaphore.signal()
            } catch {
                semaphore.signal()
                print(error)
            }
            }
            .resume()
        semaphore.wait()
        return responseModel
    }
    
    /// URl OpenWeatherMap
    private func urlApiOpenWeather(url: String, language: String, apiKey: String, lat: Double, lon: Double) -> String {
        return "\(url)lat=\(lat)&lon=\(lon)&cnt=14&lang=\(language)&APPID=\(apiKey)"
    }
}
