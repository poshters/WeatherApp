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
 
    private var getWeather: WeatherForecast?
    private let refresh = UIRefreshControl()
    private let locationManager = CLLocationManager()
    private var avPlayer = AVPlayer()
    private var avPlayerLayer = AVPlayerLayer()
    private var paused: Bool = false
    private static let maxHeaderHeight: CGFloat = 200
    private static let minHeaderHeight: CGFloat = 154
    private var titleCity: String?
    
    // MARK: Refresh data in TableView
    @objc private func refreshData() {
        refresh.beginRefreshing()
        updateData()
        refresh.endRefreshing()
    }
    
    /// Save data in Data Base
    private func updateData() {
        ApiWeather().getWeatherForecastByCity(
            lat: UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude),
            long: UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude)) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let result = result {
                        UserDefaults.standard.set(result.city?.lat,
                                                  forKey:
                            UserDefaultsConstant.latitude)
                        UserDefaults.standard.set(result.city?.lon,
                                                  forKey:
                            UserDefaultsConstant.longitude)
                        DBManager.addDB(object: result)
                        self?.getData()
                    } else {
                        print("\(String(describing: error?.localizedDescription))")
                    }
                }
        }
    }
    
    /// Get data with Data Base
    private func getData() {
        let results = DBManager.getWeatherForecastByCity(
            lat: UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude),
            long: UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude))
        self.getWeather = results?.first
        if let weather = self.getWeather {
            
            /// set name city in NavigetionTitle
            self.titleCity = weather.city?.name ?? DefoultConstant.empty
            
            /// set data in CollectionView
            self.customColectionView.fill(weathers: weather)
            
            /// set data in HeaderView
            self.headerView.accessToOutlet(
                city: weather.city?.name ?? DefoultConstant.empty,
                dayOfweeK: DayOfWeeks.dayOfWeeks(date: weather.list.first?.dateWeather),
                temperature: TemperatureFormatter.temperatureFormatter(weather.list.first?.max),
                desc: weather.list.first?.desc ?? DefoultConstant.empty,
                icon: weather.list.first?.icon ?? DefoultConstant.empty)
            
            ///Notification
            SheduleNotification.sheduleNotification(title: "\(weather.city?.name ?? DefoultConstant.empty)",
                subtitle: "\(String(describing: weather.list.first?.desc))", body: """
                \(NotificationConstant.maxTemp)\(TemperatureFormatter.temperatureFormatter(weather.list.first?.max)),
                \(NotificationConstant.minTemp)\(TemperatureFormatter.temperatureFormatter(weather.list.first?.min))
                """)
        }
    }
    
    // MARK: - Alert
    private func alertClose(_ message: String? = nil) {
        let alert = UIAlertController(title: AlertConstant.title, message: message ?? AlertConstant.message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: AlertConstant.actionTitle, style: .cancel) { (_) in
            self.refreshData()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    var selectedRoW: Weather?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRow = selectedRoW {
            if segue.identifier == "infoVC" {
                (segue.destination as? InfoViewController)?.selectedRow = selectedRow
            }
        }
    }
}

// MARK: - Life Cycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        refreshData()
        self.navigationItem.title = DefoultConstant.title
        customColectionView.backgroundColor = UIColor.clear
        customColectionView.customCollectionDelegate = self
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        heightConstraint.constant = MainViewController.maxHeaderHeight
        self.getData()
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
        self.videoBackground(videoName: self.getWeather?.list.first?.icon ?? DefoultConstant.empty)
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
    
    @IBAction func locationButtonAction(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
        if let weatherAtIndex = getWeather?.list[indexPath.row] {
            self.selectedRoW = weatherAtIndex
            collectionView.deselectItem(at: indexPath, animated: false)
            performSegue(withIdentifier: "infoVC", sender: self)
        }
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
