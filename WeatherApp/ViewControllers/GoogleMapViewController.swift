//
//  GoogleMapViewController.swift
//  WeatherApp
//
//  Created by MacBook on 10/31/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

final class GoogleMapViewController: UIViewController {
    // MARK: - UI
    @IBOutlet private weak var mapView: GMSMapView!
    
    // MARK: - Instance
    private let locationManager = CLLocationManager()
    private let allCity = DBManager.getAllCities()
    private var markers = [GMSMarker]()
    private var locationManagers = CLLocationManager()
    
    /// Markers on map
    private func markersMap() {
        if let allCity = allCity {
            mapView.camera = GMSCameraPosition.camera(withLatitude:
                UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude),
                                                      longitude:
                UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude),
                                                      zoom: 10)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:
                UserDefaults.standard.double(forKey: UserDefaultsConstant.latitude),
                                                                    longitude:
                UserDefaults.standard.double(forKey: UserDefaultsConstant.longitude)))
            
            let infoWindow = Bundle.main.loadNibNamed(MapPinView.className, owner: self.view,
                                                      options: nil)?.first as? MapPinView
            
            let result = DBManager.getWeatherForecastByCity(lat: marker.position.latitude,
                                                            long: marker.position.longitude)
            if let result = result?.first {
                infoWindow?.accessToOutlet(temperature:
                    TemperatureFormatter.temperatureFormatter(result.list.first?.max),
                                           city: result.city?.name ?? DefoultConstant.empty,
                                           description: result.list.first?.desc ?? DefoultConstant.empty,
                                           icon: result.list.first?.icon ?? DefoultConstant.empty)
            }
            
            marker.map = mapView
            mapView.selectedMarker = marker
            for coord in allCity {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon))
                markers.append(marker)
                marker.map = mapView
            }
        }
    }
    
    /// Show location on map
    private func location() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
}

// MARK: - Life cycle
extension GoogleMapViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        markersMap()
        location()
        Analytics.logEvent("GoogleMapVC", parameters: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        markersMap()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - GMSMapViewDelegate
extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        UserDefaults.standard.set(marker.position.latitude, forKey: UserDefaultsConstant.latitude)
        UserDefaults.standard.set(marker.position.longitude, forKey: UserDefaultsConstant.longitude)
        self.tabBarController?.selectedIndex = 0
        Analytics.logEvent("DidTapInfoWindow", parameters: nil)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        guard let infoWindow = Bundle.main.loadNibNamed(MapPinView.className, owner: self.view,
                                                        options: nil)?.first as? MapPinView else {
                                                            return nil
        }
        let result = DBManager.getWeatherForecastByCity(lat: marker.position.latitude,
                                                        long: marker.position.longitude)
        if let result = result?.first {
            infoWindow.accessToOutlet(temperature: TemperatureFormatter.temperatureFormatter(result.list.first?.max),
                                      city: result.city?.name ?? DefoultConstant.empty,
                                      description: result.list.first?.desc ?? DefoultConstant.empty,
                                      icon: result.list.first?.icon ?? DefoultConstant.empty)
        }
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture == true {
            mapView.selectedMarker = nil
        }
    }
}
