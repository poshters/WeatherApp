import Foundation

struct AppDelegateConstant {
    static let googleAPIKey = "AIzaSyBfjgKmGmrqf538QljpSddlvH9gXsMWk-M"
}

struct DBManagerConstant {
    static let cityNameFilter = "city.lon = %@ AND city.lat = %@"
}

struct ApiWeatherConstant {
     static let openWeather5Day =  "https://api.openweathermap.org/data/2.5/forecast?"
    static let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/forecast/daily?"
    static let openWeatherMapAPIKey = "695ec8629eeaf925d9d4e9139ac14a69"
}

struct DefoultConstant {
    static let empty = ""
    static let newLine = "\n"
    static let title = "WeatherApp"
}

struct UserDefaultsConstant {
    static let longitude = "long"
    static let latitude = "lat"
}

struct TemperatureFormatterConstant {
    static let identifier = "it_IT"
    static let format = "%@"
}

struct DayOfWeeksConstant {
    static let abbreviatedDayOfWeek = "EEE"
    static let dayOfWeek = "EEEE, "
    static let day = "EEEE"
    static let abbreviatedMonth = "MMMd"
    static let month = "MMMMd"
    static let hour = "HH:mm"
}

struct NotificationConstant {
    static let identifier = "WeatheNotifacation"
    static let maxTemp = "hight:"
    static let minTemp = "low:"
}

struct ModelConstant {
    static let weatherForecastPrimaryKey = "realmId"
    static let weatherPrimaryKey = "dateWeather"
    static let cityPrimaryKey = "name"
}

struct WeatherAttributes {
    static let humidity = "Humidity: "
    static let humiditySymbol = " %"
    static let pressure = "Pressure: "
    static let pressureSymbol = " hPa"
    static let wind = "Wind: "
    static let windSymbol = " km/h"
}

struct AlertConstant {
    static let title = "Error"
    static let message = "No connection to the internet"
    static let actionTitle = "Try again"
}

struct OtherConstant {
    static let noCordinates = "No coordinates"
    static let error = "Error: "
    static let backgroundImage = "1"
}
