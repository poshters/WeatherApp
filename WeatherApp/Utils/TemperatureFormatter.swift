import Foundation

final class TemperatureFormatter {
    
    /// Convert temperature from kelvin to celsium
    ///
    /// - Parameter kelvinTemp: Double
    /// - Returns: String
    static func temperatureFormatter(_ kelvinTemp: Double?) -> String {
        guard let kelvinTemp = kelvinTemp else {
            return DefoultConstant.empty
        }
        
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: TemperatureFormatterConstant.identifier)
        formatter.numberFormatter.maximumFractionDigits = 0
        let temperature = Measurement(value: kelvinTemp, unit: UnitTemperature.kelvin)
        return (String(format: TemperatureFormatterConstant.format, formatter.string(from: temperature)))
    }
}
