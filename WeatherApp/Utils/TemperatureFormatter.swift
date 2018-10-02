import Foundation

final class TemperatureFormatter {
    static func temperatureFormatter(_ kelvinTemp: Double) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: TemperatureFormatterConstant.identifier)
        formatter.numberFormatter.maximumFractionDigits = 0
        let temperature = Measurement(value: kelvinTemp, unit: UnitTemperature.kelvin)
        return (String(format: TemperatureFormatterConstant.format, formatter.string(from: temperature)))
    }
}