//
//  ViewController.swift
//  Clima
//
//  Created by Amad Salmon on 20/07/2020.
//  Copyright © 2020 Amad Salmon. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print("searchPressed",searchTextField.text!)
    }
    @IBAction func searchEditingEnded(_ sender: UITextField) {
        searchTextField.endEditing(true)
        print("searchEditingEnded",searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        print("textFieldShouldReturn",textField.text!)
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        textField.text = ""
        print("textFieldDidEndEditing")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Search location..."
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        cityLabel.text = weather.cityName
        temperatureLabel.text = weather.temperatureString
        print("\(weather.conditionName)")
        conditionImageView.image = UIImage(systemName: "\(weather.conditionName)")
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("lat=\(lat) ; lon= \(lon)")
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func locateButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

