//
//  CurrentWeatherData.swift
//  Sunny
//
//  Created by Сергей Цыганков on 03.06.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//


//это все копируем из json
import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    //так написано на сайте, но переименовав, можем написать так
//    let feels_like: Double
    let feelsLike: Double
    
    //щас происходит изменение названий переменных
    //изначально они обязаны совпадать с тем, что на сайте
    //изменяется по стандартной форме!!!
    enum CodingKeys: String, CodingKey {
        case temp //ее менять не будем, так что оставляем так же
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
}
