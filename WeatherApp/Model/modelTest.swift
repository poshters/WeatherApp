//
//  modelTest.swift
//  WeatherApp
//
//  Created by mac on 10/4/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

struct Welcome: Decodable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [ListH]
    let city: City
}

struct CityH: Decodable {
    let id: Int
    let name: String
    let coord: CoordH
    let country: String
    let population: Int
}

struct CoordH: Decodable {
    let lat, lon: Double
}

struct ListH: Decodable {
    let dt: Int
    let main: MainClass
    let weather: [WeatherH]
    let clouds: Clouds
    let wind: Wind
    let sys: Sys
    let dtTxt: String
    let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

struct Clouds: Decodable {
    let all: Int
}

struct MainClass: Decodable {
    let temp, tempMin, tempMax, pressure: Double
    let seaLevel, grndLevel: Double
    let humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Rain: Decodable {
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Sys: Codable {
//    let pod: Pod
}
//
//enum Pod: String, Codable {
//    case d = "d"
//    case n = "n"
//}

struct WeatherH: Decodable {
    let id: Int
    let main: MainEnum
    let description: Description
    let icon: String
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

struct Wind: Decodable {
    let speed, deg: Double
}
