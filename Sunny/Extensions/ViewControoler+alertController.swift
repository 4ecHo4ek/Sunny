//
//  ViewControoler+alertController.swift
//  Sunny
//
//  Created by Сергей Цыганков on 03.06.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import UIKit

//так как работаем с расширением нашего контроллера, то в нем доступно все, что есть здесь
extension ViewController {
    
    func presentSearchAlertController(withTitile title: String?, message: String?, style: UIAlertController.Style, comlitionHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["Хьюстон", "Москва", "Нью Йорк"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Поиск", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                //если имя содержит несколько элементов, разделенных пробелом, то оно их разделяем и соединяет со знаком %20 между ними
                let city = cityName.split(separator: " ").joined(separator: "%20")
                //@escaping нужно дописать, так как один клоужер закрылся, а другой еще нет
                comlitionHandler(city)
                
                //данный вариант так же верен
           //     self.networkWeatherManager.fetchCurrentWeather(forCity: cityName)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
}
