//
//  WeatherManager.swift
//  Clima
//
//  Created by Amad Salmon on 20/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    let cityName = "London"
    let apiKey = "f858bfc187647d94e0866c7ddb256dfe"
    let units = "metric"
    
    func fetchWeather(cityName: String){
        let weatherURL = "\(baseURL)?q=\(cityName)&appid=\(apiKey)&units=\(units)"
        // e.g.: api.openweathermap.org/data/2.5/weather?q=London&appid=f858bfc187647d94e0866c7ddb256dfe
        print(weatherURL)
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
                    print(error!)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
}
