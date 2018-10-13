import UIKit
import RealmSwift
import CoreLocation
import GooglePlaces
import AVFoundation

final class MainViewController: UIViewController {
    ///UI
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerView: HeaderView!
    @IBOutlet private weak var customColectionView: CustomCollectionView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var maxTemp: UILabel!
    
    /// Instance
    private(set) var weatherForecast = WeatherForecast()
    
    private var getApiWeather = WeatherForecast()
    private let refresh = UIRefreshControl()
    private let locationManager = CLLocationManager()
    private var avPlayer = AVPlayer()
    private var avPlayerLayer = AVPlayerLayer()
    private var paused: Bool = false
    private static let maxHeaderHeight: CGFloat = 200
    private static let minHeaderHeight: CGFloat = 154
    private var titleCity: String = DefoultConstant.empty
    
    /// MainVC, set data in fields
    func setDataMainVC() {
        cityLabel.text = weatherForecast.city?.name ?? DefoultConstant.empty
        date.text = DayOfWeeks.dayOfWeeks(date: weatherForecast.list[0].dateWeather)
        descLabel.text = weatherForecast.list.first?.desc
        maxTemp.text = TemperatureFormatter.temperatureFormatter((weatherForecast.list[0].max))
    }
    
    // MARK: Refresh data in TableView
    @objc private func refreshData() {
        refresh.beginRefreshing()
        checkData()
        refresh.endRefreshing()
    }
    
    /// Data validation in the database
    private func checkData() {
        let results = getDBApi(lat: UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude),
                               long: UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude))
        if results?.city == nil {
            alertClose()
        } else {
            if let result = results {
                weatherForecast = result
                customColectionView.fill(weathers: weatherForecast)
            }
        }
    }
    
    // MARK: - Alert
    private func alertClose() {
        let alert = UIAlertController(title: AlertConstant.title, message: AlertConstant.message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: AlertConstant.actionTitle, style: .cancel) { (_) in
            self.refreshData()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Save data in the database
    func getDBApi(lat: Double, long: Double) -> WeatherForecast? {
        getApiWeather = WeatherForecast()
        if Reachability.isConnectedToNetwork() {
            getApiWeather = ApiWeather().getWeatherForecastByCity(lat: lat, long: long )
            DBManager.addDB(object: getApiWeather)
            return getApiWeather
        }
        alertClose()
        let results = DBManager.getWeatherForecastByCity(city: weatherForecast.city ?? City())
        return results
    }
    
    var selectedRoW = Weather()
    
    private func animationTransition() {
        let transition = CATransition()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromRight
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoVC" {
            (segue.destination as? InfoViewController)?.selectedRow = selectedRoW
        }
    }
}

// MARK: - Life Cycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.navigationItem.title = DefoultConstant.title
        refreshData()
        SheduleNotification.sheduleNotification(title: "\(weatherForecast.city?.name ?? DefoultConstant.empty)",
            subtitle: "\(weatherForecast.list[0].desc)", body: """
            \(NotificationConstant.maxTemp)\(TemperatureFormatter.temperatureFormatter(weatherForecast.list[0].max)),
            \(NotificationConstant.minTemp)\(TemperatureFormatter.temperatureFormatter(weatherForecast.list[0].min))
            """)
        customColectionView.backgroundColor = UIColor.clear
        customColectionView.customCollectionDelegate = self
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.5)
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
        titleCity = weatherForecast.city?.name ?? DefoultConstant.empty
        heightConstraint.constant = MainViewController.maxHeaderHeight
        videoBackground(videoName: weatherForecast.list[0].icon)
        headerView.accessToOutlet(city: weatherForecast.city?.name ?? DefoultConstant.empty,
                                  dayOfweeK: DayOfWeeks.dayOfWeeks(date: weatherForecast.list[0].dateWeather),
                                  temperature: TemperatureFormatter.temperatureFormatter(weatherForecast.list[0].max),
                                  desc: weatherForecast.list[0].desc, icon: weatherForecast.list[0].icon)
    }
}

// MARK: - CurrentLocation
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude,
            let long = locations.last?.coordinate.longitude {
            UserDefaults.standard.set(lat, forKey: UserDefaultsConstant.latitude)
            UserDefaults.standard.set(long, forKey: UserDefaultsConstant.longitude)
            self.refreshData()
        } else {
            print(OtherConstant.noCordinates)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - Сity ​​search
extension MainViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        UserDefaults.standard.set(place.coordinate.latitude, forKey: UserDefaultsConstant.latitude)
        UserDefaults.standard.set(place.coordinate.longitude, forKey: UserDefaultsConstant.longitude)
        customColectionView.refreshCollection()
        self.refreshData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(OtherConstant.error, error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: - UIButtonAction
extension MainViewController {
    
    /// ChengeScrollingCustomColectionView
    @IBAction func changeScrollColectionViewButton(_ sender: Any) {
        customColectionView.scrollChange()
    }
    
    /// FindeCityButton
    @IBAction func findeCityButton(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

// MARK: - VideoBackGround
extension MainViewController {
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

// MARK: - CustomCollectionViewDelegate
extension MainViewController: CustomCollectionViewDelegate {
    func didSelectRowAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        selectedRoW = weatherForecast.list[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: false)
        performSegue(withIdentifier: "infoVC", sender: self)
    }
    
    func didChangeOffsetY(_ offsetY: CGFloat) {
        let offset = offsetY
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor: CGFloat = -(offset) / heightConstraint.constant
            let headerSizevariation =
                ((heightConstraint.constant * (1.0 + headerScaleFactor)) - heightConstraint.constant) / 2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            headerView.layer.transform = headerTransform
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0,
                                                     max(-MainViewController.minHeaderHeight, -offset), 0)
            headerView.layer.transform = headerTransform
        }
        
        if offset >= heightConstraint.constant / 2 {
            UIView.animate(withDuration: 0.3) {
                self.headerView.position()
                self.headerView.alphaImage(alpha: 1)
                self.navigationItem.title = self.titleCity
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.headerView.defoultPosition()
                self.headerView.alphaImage(alpha: 0)
                self.navigationItem.title = DefoultConstant.title
            }
        }
    }
}
