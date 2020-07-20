//
//  WeatherManager.swift
//  Clima
//
//  Created by Amad Salmon on 20/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    let cityName = "London"
    let apiKey = "f858bfc187647d94e0866c7ddb256dfe"
    let units = "metric"
    
    func fetchWeather(cityName: String){
        let weatherURL = "\(baseURL)?q=\(cityName)&appid=\(apiKey)&units=\(units)"
        // e.g.: api.openweathermap.org/data/2.5/weather?q=London&appid=f858bfc187647d94e0866c7ddb256dfe
        //print(weatherURL)
        performRequest(urlString: weatherURL)
    }
    
    func performRequest(urlString: String){
        // 1. Create an URL
        if let url = URL(string: urlString){
            // 2. Create an URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString!)
                    if let weather = self.parseJSON(safeData){
                        /** Long-running tasks such as networking are often executed in the background, and provide a completion handler to signal completion.
                            Attempting to read or update the UI from a completion handler may cause problems.
                            Dispatch the call to update the label text to the main thread.
                         */
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateWeather(weather: weather)
                        }
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
            
            let cityName = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            
            print(weather.conditionName)
            
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
