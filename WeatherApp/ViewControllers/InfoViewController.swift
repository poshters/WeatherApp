import UIKit
import AVFoundation

final class InfoViewController: UIViewController {
    /// instance
    private let wetherTableView = MainViewController()
    private let dateFormatter = DateFormatter()
    private let dayOfWeek = DateFormatter()
    private var avPlayer = AVPlayer()
    private var avPlayerLayer = AVPlayerLayer()
    private var paused: Bool = false
    var selectedRow = Weather()
    
    /// UI
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!
}

// MARK: - Life cycle
extension InfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setInfoWether()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        avPlayerLayer.player = self.avPlayer
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.play()
        paused = true
        NotificationCenter.default.removeObserver(self)
        avPlayerLayer.player = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoBackground(videoName: selectedRow.icon)
    }
}

// MARK: - Set data in field
extension InfoViewController {
    func setInfoWether() {
        dayLabel.text = DayOfWeeks.dayOfWeeks(date: selectedRow.dateWeather)
        maxTempLabel.text = TemperatureFormatter.temperatureFormatter(selectedRow.max)
        minTempLabel.text = TemperatureFormatter.temperatureFormatter(selectedRow.min)
        descriptionLabel.text = selectedRow.desc
        humidityLabel.text = "\(WeatherAttributes.humidity)\(selectedRow.humidity)\(WeatherAttributes.humiditySymbol)"
        pressureLabel.text =
        "\(WeatherAttributes.pressure)\(Int(selectedRow.pressure))\(WeatherAttributes.pressureSymbol)"
        windLabel.text = "\(WeatherAttributes.wind)\(Int(selectedRow.speed))\(WeatherAttributes.windSymbol)"
        iconImage.image = UIImage(named: selectedRow.icon)
    }
}

// MARK: - VideoBackground
extension InfoViewController {
    func videoBackground(videoName: String) {
        guard let theURL = Bundle.main.url(forResource: videoName, withExtension: "mp4")
            else {
                return
        }
        avPlayer = AVPlayer(url: theURL)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        guard let pusk: AVPlayerItem = notification.object as? AVPlayerItem else {
            return
        }
        pusk.seek(to: CMTime.zero, completionHandler: nil)
    }
}
