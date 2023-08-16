//
//  WeatherManager.swift
//  Clima
//
//  Created by Edgar Cisneros on 22/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,_ weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    let appid = SecureKeys().appid
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)&appid=\(appid)"
        
        performRequest(with: urlString)
    }
    
    
    func fetchWeather(latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees){
        
        let urlString = "\(weatherURL)&appid=\(appid)&lat=\(lat)&lon=\(lon)"
        
        performRequest(with: urlString)
        
    }
    
    
    func performRequest(with urlString: String){
        
        //Networking
        //1.Create a URL
        if let url = URL(string: urlString){
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let name = decodedData.name
            let id = decodedData.weather[0].id

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }

    }
    
   
    
}


