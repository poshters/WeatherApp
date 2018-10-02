import UIKit

final class CityTableViewCell: UITableViewCell {
    ///UI
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - SetdDataInFields
extension CityTableViewCell {
    func setLabelData(city: String, max: String, min: String) {
        self.cityLabel.text = city
        self.maxTempLabel.text = max
        self.minTempLabel.text = min
    }
}
