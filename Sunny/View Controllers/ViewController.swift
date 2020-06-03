//
//  ViewController.swift
//  Sunny
//
//  Created by Сергей Цыганков on 03.06.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    @IBAction func searchButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitile: "Введите название города", message: nil, style: .alert) { [unowned self] city in // добавляем эти скобки для удаления утечки памяти
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //подписываемся для делегирования
        // networkWeatherManager.delegate = self
        networkWeatherManager.onComplition = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterface(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString + "ºC"
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTempiratureString + "ºC"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
}
/**
 extension ViewController /**: NetworkWeatherManagerDelegate*/ {
 func updateInteface(_: NetworkWeatherManager, with currentWeather: CurrentWeather) {
 print(currentWeather.cityName)
 }
 
 }
 */

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
