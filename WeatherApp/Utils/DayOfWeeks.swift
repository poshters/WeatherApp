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
}
