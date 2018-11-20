import UIKit

final class HorizontalCollectionViewCell: UICollectionViewCell {
    // MARK: - UI
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var dateWeatherLabel: UILabel!
    @IBOutlet private weak var iconWeatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    /// Access to outlet
    ///
    /// - Parameters:
    ///   - date: String
    ///   - icon: String
    func accessToOutlet(date: String, icon: String) {
        self.dateWeatherLabel.text = date
        self.iconWeatherImage.image = UIImage(named: icon)
    }
}
