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

    func weatherForecastByCity(lat: Double, long: Double) {
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        let weatherRequestURL = URL(string: urlApiOpenWeather(url: ApiWeatherConstant.openWeather5Day,
                                                                    language: language,
                                                                    apiKey: ApiWeatherConstant.openWeatherMapAPIKey,
                                                                    lat: lat,
                                                                    lon: long))
         session.dataTask(with: weatherRequestURL!) { (data, response, error) in
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
                let responseModel = try jsonDecoder.decode(Welcome.self, from: data)
                print(responseModel)
                semaphore.signal()
            } catch {
                semaphore.signal()
                print(error)
            }
            }
            .resume()
        semaphore.wait()
//        print(responseModel)
//        return responseModel
    }

    /// URl OpenWeatherMap
    private func urlApiOpenWeather(url: String, language: String, apiKey: String, lat: Double, lon: Double) -> String {
        return "\(url)lat=\(lat)&lon=\(lon)&lang=\(language)&APPID=\(apiKey)"
    }
}
