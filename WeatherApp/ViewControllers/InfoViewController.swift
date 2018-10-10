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
    private var hourlyWeather = WeatherHourlyMainModel()
    private var selectedIndexPath: Int?
    var selectedRow = Weather()
    let weatherCity = WeatherForecast()
    
    /// UI
    @IBOutlet private weak var currentHourLabel: UILabel!
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var hourlyHeaderView: HourlyHeaderView!
    
    ///Current Time
    func accessToOutlet() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date).capitalized
        dateFormatter.dateFormat = "HH:mm"
        
        let dateString = dateFormatter.string(from: date)
        currentHourLabel?.text = dateString
        dayOfWeekLabel.text = day
    }
    
    /// Time didSelectRow
    func currenTime(hours: Int, dayOfWeek: Int) {
        currentHourLabel.text = DayOfWeeks.dayOfHours(date: hours)
        dayOfWeekLabel.text = DayOfWeeks.dayOfWeek(date: dayOfWeek)
    }
}

// MARK: - Life cycle
extension InfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyWeather = ApiHourlyWeather().weatherForecastByCity(lat: UserDefaults.standard.double(
            forKey: UserDefaultsConstant.latitude),
                                                                 long: UserDefaults.standard.double(
                                                                    forKey: UserDefaultsConstant.longitude))
        //        let cityName = hourlyWeather.city
        DBManager.addDBHourly(object: hourlyWeather)
        accessToOutlet()
        //        let listHourly = DBManager.getWeatherForecastByCity(city: cityName!, date:
        //          hourlyWeather.list[0].dateWeather)
        //        print("\(hourlyWeather.list[0].dateWeather) +  ---- + \(listHourly)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        avPlayerLayer.player = self.avPlayer
        avPlayer.play()
        paused = false
        view.clipsToBounds = true
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.selectedIndexPath == indexPath.row {
            return 153
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return    self.hourlyWeather.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: HourlyTableViewCell.className,
                                 bundle: nil), forCellReuseIdentifier: HourlyTableViewCell.className)
        if let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.className,
                                                    for: indexPath) as? HourlyTableViewCell {
            
            cell.accessToOutlet(hour: DayOfWeeks.timeToDay(hour: hourlyWeather.list[indexPath.row].dateWeather),
                                temp: TemperatureFormatter.temperatureFormatter(
                                    hourlyWeather.list[indexPath.row].main?.temp ?? 0.0))
            return cell
        }
        return HourlyTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currenTime(hours: hourlyWeather.list[indexPath.row].dateWeather,
                   dayOfWeek: hourlyWeather.list[indexPath.row].dateWeather)
       
        if indexPath.row == self.selectedIndexPath {
            self.selectedIndexPath = nil
        } else {
            self.selectedIndexPath = indexPath.row
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

// MARK: - Action
extension InfoViewController {
    /// Current time
    @IBAction func buttonAction(_ sender: Any) {
        accessToOutlet()
    }
    /// Button Back
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
