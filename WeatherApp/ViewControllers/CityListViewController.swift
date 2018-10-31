import UIKit
import RealmSwift

final class CityListViewController: UIViewController {
    ///UI
    @IBOutlet private weak var cityTableView: UITableView!
    
    ///Instance
    private let wetherTableVC = MainViewController()
    private let listCity = DBManager.getAllCities()
    
    /// SetImageBackground
    private func setImageBackground() {
//        cityTableView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let backgroundImage = UIImageView(image: UIImage(named: OtherConstant.backgroundImage))
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(backgroundImage, at: 0)
        NSLayoutConstraint.activate([backgroundImage.leftAnchor.constraint(
            equalTo: view.leftAnchor),
                                     backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
                                     backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

// MARK: - Life Cycle
extension CityListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cityTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.backgroundColor = UIColor.clear
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCity?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellCitytWeatherDB = listCity?[indexPath.row] else {
            return CityTableViewCell()
        }
        let listWeather = DBManager.getWeatherForecastByCity(lat: cellCitytWeatherDB.lat,
                                                             long: cellCitytWeatherDB.lon)?.first
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.className,
                                                    for: indexPath) as? CityTableViewCell {
            cell.setLabelData(city: cellCitytWeatherDB.name,
                              max: "\(TemperatureFormatter.temperatureFormatter(listWeather?.list.first?.max ?? 0))",
                min: TemperatureFormatter.temperatureFormatter(listWeather?.list.first?.min ?? 0))
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        return CityTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = listCity?[indexPath.row]
        UserDefaults.standard.set(selectedCity?.lat, forKey: UserDefaultsConstant.latitude)
        UserDefaults.standard.set(selectedCity?.lon, forKey: UserDefaultsConstant.longitude)
        cityTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let deletedCity = listCity?[indexPath.row] else {
            return
        }
        if editingStyle == .delete {
            ///Delete with Data Base
            DBManager.deleteHourlyWeather(city: deletedCity)
            do {
                let realm = try Realm()
                try realm.write {
                    guard let deletedWeatherForecast =
                        realm.objects(WeatherForecast.self).filter(DBManagerConstant.cityNameFilter,
                                                                   deletedCity.lon, deletedCity.lat).first else {
                                                                    return
                    }
                    realm.delete(deletedWeatherForecast.list)
                    realm.delete(deletedWeatherForecast)
                    realm.delete(deletedCity)
                }
            } catch {
                return
            }
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

// MARK: - UIButtonAction
extension CityListViewController {
    
    /// EditTable
    @IBAction func editingTable(_ sender: Any) {
        cityTableView.isEditing = !cityTableView.isEditing
    }
}
