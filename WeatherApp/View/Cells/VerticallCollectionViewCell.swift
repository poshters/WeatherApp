import UIKit

final class VerticallCollectionViewCell: UICollectionViewCell {
    ///UI
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var iconWeatherImage: UIImageView!
    @IBOutlet private weak var dateWeatherLabel: UILabel!
    @IBOutlet private weak var descriptionWetherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    ///AccessToOutlet
    func accessToOutlet(date: String, desc: String, icon: String) {
        self.dateWeatherLabel.text = date
        self.descriptionWetherLabel.text = desc
        self.iconWeatherImage.image = UIImage(named: icon)
    }
}
