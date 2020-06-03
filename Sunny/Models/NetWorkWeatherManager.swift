//
//  NetWorkWeatherManager.swift
//  Sunny
//
//  Created by Сергей Цыганков on 03.06.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import Foundation
import CoreLocation

/**
//подписываем под использование класса
protocol NetworkWeatherManagerDelegate: class {
    //в качестве парамета добавляем объект делегирования (чтоб не названия не путались)
    func updateInteface(_: NetworkWeatherManager, with currentWeather: CurrentWeather)
}
*/

//здесь класс для того, чтоб мы могли наследоваться от этого кода
class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    
    
    //можно длеать через клоужеры
    var onComplition: ((CurrentWeather) -> Void)?
    
    //можно передавать через делегата
  // weak var delegate: NetworkWeatherManagerDelegate?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
           urlString =
            "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(appid)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString =
            "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(appid)&units=metric"
        }
        
        performReques(WithURLString: urlString)
        
    }
    
    
    private func performReques(WithURLString urlString: String) {
        //создаем юрл (тут происходит проверка существует ли такой адресс)
               guard let url = URL(string: urlString) else { return }
               //создаем ссесию для работы с юрл адрессом
               let session = URLSession(configuration: .default)
               //создаем запрос (в хендлере данныеб ответ сурвераб ошибка)
               let task = session.dataTask(with: url) { (data, response, error) in
                   //проверяем что информация есть
                   if let data = data {
                       //распаршиваем json
                       if let currentWeather = self.parseJSON(withData: data) {
                           //делегат передает инфу во вью контроллер
                           //self.delegate?.updateInteface(self, with: currentWeather)
                           self.onComplition?(currentWeather)
                       }
                   }
               }
               //следующая строчка должна быть написана (так написано в документации)
               //тут выполняется запров
               task.resume()
    }
    
    
    
    
    //раскладываем (парсим) данные по созданной модели (CurrentWeatherData)
    private func parseJSON(withData data: Data) -> CurrentWeather? {
        //создаем декодер
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather =
                CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
}
