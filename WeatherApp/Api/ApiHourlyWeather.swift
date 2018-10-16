//
//  ApiHourlyWeather.swift
//  WeatherApp
//
//  Created by mac on 10/3/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

final class ApiHourlyWeather {
    private let lat = UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude)
    private let long = UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude)
    private let language = Locale.current.languageCode ?? DefoultConstant.empty
    
    func weatherForecastByCity(lat: Double, long: Double,
                               completion: ((WeatherHourlyMainModel?, Error?) -> Void)? = nil) {
        let session = URLSession.shared
        guard let weatherRequestURL = URL(string: urlApiOpenWeather(url: ApiWeatherConstant.openWeather5Day,
                                                                    language: language,
                                                                    apiKey: ApiWeatherConstant.openWeatherMapAPIKey,
                                                                    lat: lat,
                                                                    lon: long)) else {
                                                                        completion?(nil, nil)
                                                                        return
        }
        session.dataTask(with: weatherRequestURL) { (data, _, error) in
            guard let data = data else {
                 completion?(nil, nil)
                return
                
            }
            guard  error == nil else {
                completion?(nil, error)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
               let responseModel = try jsonDecoder.decode(WeatherHourlyMainModel.self, from: data)
                 completion?(responseModel, nil)
            } catch {
               completion?(nil, error)
                print(error)
            }
            }
            .resume()
    }
    
    /// URl OpenWeatherMap
    private func urlApiOpenWeather(url: String, language: String, apiKey: String, lat: Double, lon: Double) -> String {
        return "\(url)lat=\(lat)&lon=\(lon)&lang=\(language)&APPID=\(apiKey)"
    }
}
