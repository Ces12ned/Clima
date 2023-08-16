//
//  WeatherData.swift
//  Clima
//
//  Created by Edgar Cisneros on 03/01/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


struct WeatherData: Codable {
    
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable{
    
    let temp, feelsLike, tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"

        }
}

struct Weather: Codable{
    
    let description: String
    let id: Int
    let main: String
}

