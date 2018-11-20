import UIKit

final class CityTableViewCell: UITableViewCell {
    // MARK: - UI
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

// MARK: - Set data in fields
extension CityTableViewCell {
    /// Set label data
    ///
    /// - Parameters:
    ///   - city: String
    ///   - max: String
    ///   - min: String
    func setLabelData(city: String, max: String, min: String) {
        self.cityLabel.text = city
        self.maxTempLabel.text = max
        self.minTempLabel.text = min
    }
}
