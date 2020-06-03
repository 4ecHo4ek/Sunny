//
//  CurrentWeather.swift
//  Sunny
//
//  Created by Сергей Цыганков on 03.06.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        //так записывается округление
        return String(format: "%.0f", temperature)
    }
    
    let feelsLikeTempirature: Double
    var feelsLikeTempiratureString: String {
        return String(format: "%.0f", feelsLikeTempirature)
    }
    
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    //достаем из распрасеннного json и заносим в структуру, которая уже и будет обновлять лейблы
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTempirature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
