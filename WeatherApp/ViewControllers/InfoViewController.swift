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
    private var selectedIndexPath: Int?
    private var listHourly: [ListH]?
    var selectedRow: Weather?
    
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
    
///Save data in DataBase
private func updateData() {
    ApiHourlyWeather().weatherForecastByCity(
        lat: UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude),
        long: UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude)) { result, error in
            DispatchQueue.main.async {
                if let result = result {
                    DBManager.addDBHourly(object: result)
                    self.getData()
                } else {
                    print(String(describing: error?.localizedDescription))
                }
                }
            }
    }
    
    ///Get data with DataBase
    private func getData() {
        self.listHourly = DBManager.getWeatherForecastByCity(
            lat: UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude),
            long: UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude),
            date: self.selectedRow?.dateWeather ?? 0)
        self.tableView.reloadData()
        }
    }

// MARK: - Life cycle
extension InfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        updateData()
        accessToOutlet()
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
        videoBackground(videoName: selectedRow?.icon ?? DefoultConstant.empty)
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
        if let listHourlyCount = listHourly?.count {
            return listHourlyCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        tableView.register(UINib(nibName: HourlyTableViewCell.className,
                                 bundle: nil), forCellReuseIdentifier: HourlyTableViewCell.className)
        if let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.className,
                                                    for: indexPath) as? HourlyTableViewCell {
            if let listHourly = listHourly?[indexPath.row] {
            cell.accessToOutlet(
                dayOfweek: DayOfWeeks.timeToDay(hour: listHourly.dateWeather),
                temp: TemperatureFormatter.temperatureFormatter(listHourly.main?.temp),
                description: "\(listHourly.weather.first?.desc ?? DefoultConstant.empty)",
                pressure: "\(Int(listHourly.main?.pressure ?? 0.0))\(WeatherAttributes.pressureSymbol)",
                humidity: "\(listHourly.main?.humidity ?? 0)\(WeatherAttributes.humiditySymbol)")
            cell.accessToImage(icon: listHourly.weather.first?.icon ?? DefoultConstant.empty)
            return cell
            }
        }
        return HourlyTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let listHourly = listHourly?[indexPath.row] {
        currenTime(hours: listHourly.dateWeather,
                   dayOfWeek: listHourly.dateWeather)
        if indexPath.row == self.selectedIndexPath {
            self.selectedIndexPath = nil
        } else {
            self.selectedIndexPath = indexPath.row
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        }
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
