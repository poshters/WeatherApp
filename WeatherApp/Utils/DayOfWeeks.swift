import Foundation

final class DayOfWeeks {
    class func dayOfWeeks(date: Int, separateDataAndDay: Bool = false ) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        let dayOfWeek = DateFormatter()
        if separateDataAndDay == true {
            dayOfWeek.dateFormat = DayOfWeeksConstant.abbreviatedDayOfWeek
            dateFormatter.setLocalizedDateFormatFromTemplate(DayOfWeeksConstant.abbreviatedMonth)
            let newLine = separateDataAndDay ? DefoultConstant.newLine : DefoultConstant.empty
            
            return  "\(dayOfWeek.string(from: date))\(newLine)\(dateFormatter.string(from: date).capitalized)"
            
        } else {
            dayOfWeek.dateFormat = DayOfWeeksConstant.dayOfWeek
            dateFormatter.setLocalizedDateFormatFromTemplate(DayOfWeeksConstant.month)
            let newLine = separateDataAndDay ? DefoultConstant.newLine : DefoultConstant.empty
            
            return  "\(dayOfWeek.string(from: date))\(newLine)\(dateFormatter.string(from: date).capitalized)"
        }
    }
    
    class func dayOfWeek(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dayOfWeek = DateFormatter()
        dayOfWeek.dateFormat = DayOfWeeksConstant.day
        return  "\(dayOfWeek.string(from: date))"
    }
    
    class func dayOfHours(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dayOfWeek = DateFormatter()
        dayOfWeek.dateFormat = "HH:mm"
        return  "\(dayOfWeek.string(from: date))"
    }
    
    class func timeToDay(hour: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(hour))
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 6..<12 : return "Morning"
        case 12 : return "Noon"
        case 13..<17 : return "Afternoon"
        case 17..<22 : return "Evening"
        default: return "Night"
        }
    }
}
