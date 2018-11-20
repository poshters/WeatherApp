import Foundation

struct AppDelegateConstant {
    static let googleAPIKey = "AIzaSyBfjgKmGmrqf538QljpSddlvH9gXsMWk-M"
    static let googlMapAPIKey = "AIzaSyCJr82MS0tzoxSRraEpD1B7kwAbRScu3nk"
    static let googleSignIn = "666421218602-m5nrhrs94k5mk9sibosbi8o4fnmstl1l.apps.googleusercontent.com"
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
    static let pinImage = "placeholder-2"
}

struct ProfileConstant {
    static let success = "success"
    static let success2 = "success2"
    static let avatar = "Avatar"
    static let user = "user"
    static let edit = "Edit"
    static let editing = "Save"
    static let profileImage = "profile"
}

struct ProfileModelsConstant {
    static let realmID = "realmID"
}

struct CheckButtonConstants {
    static let strokeEnd = "strokeEnd"
    static let animationCycle = "animationCycle"
    static let animationLine = "animationLine"
}
