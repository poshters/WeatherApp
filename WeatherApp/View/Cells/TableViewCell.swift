import UIKit

final class TableViewCell: UITableViewCell {
    //UI
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var dateWeatherLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var imageWeather: UIImageView!
    @IBOutlet private weak var descriptionWeather: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - SetdDataInFields
extension TableViewCell {
    func setDataWeather(city: String, dateWeather: String,
                        maxTemp: String, minTemp: String, desc: String) {
        self.cityLabel.text = city
        self.dateWeatherLabel.text = dateWeather
        self.maxTempLabel.text = maxTemp
        self.minTempLabel.text = minTemp
        self.descriptionWeather.text = desc
    }
    
    func seImageWeather(imageWeather: String ) {
        self.imageWeather.image = UIImage(named: imageWeather)
    }
}
