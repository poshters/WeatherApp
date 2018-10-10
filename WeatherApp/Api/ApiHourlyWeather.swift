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
    
    func weatherForecastByCity(lat: Double, long: Double) -> WeatherHourlyMainModel {
        let semaphore = DispatchSemaphore(value: 0)
        var responseModel = WeatherHourlyMainModel()
        let session = URLSession.shared
        guard let weatherRequestURL = URL(string: urlApiOpenWeather(url: ApiWeatherConstant.openWeather5Day,
                                                                    language: language,
                                                                    apiKey: ApiWeatherConstant.openWeatherMapAPIKey,
                                                                    lat: lat,
                                                                    lon: long)) else {
                                                                        return WeatherHourlyMainModel()
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
                responseModel = try jsonDecoder.decode(WeatherHourlyMainModel.self, from: data)
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
        return "\(url)lat=\(lat)&lon=\(lon)&lang=\(language)&APPID=\(apiKey)"
    }
}
