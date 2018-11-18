//
//  WeatherCollectionViewCell.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit

enum ForecastMode {
    case dayly
    case hourly
}

class WeatherCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var cloudiness: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rainy: UILabel!
    @IBOutlet weak var snow: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    
    
    func configure(with weatherItem: WeatherItem, mode: ForecastMode ) {
        let formatter = DateFormatter()
        if mode == .dayly {
            formatter.dateFormat = "hh a"
        } else {
            formatter.dateFormat = "dd.MM"
        }
        timeLabel.text = formatter.string(from: weatherItem.forecastDate)
//        weatherIcon.image = weatherItem.shortWeatherItem.iconText.imege
        temp.text = String(describing: weatherItem.mainItem.temp!)
        minTemp.text = String(describing: weatherItem.mainItem.minTemp!)
        maxTemp.text = String(describing: weatherItem.mainItem.maxTemp!)
        pressure.text = String(describing: weatherItem.mainItem.pressure!)
        humidity.text = String(describing: weatherItem.mainItem.humidity!)
        
        windSpeed.text = String(describing: weatherItem.windItem.speed!)
        windDirection.text = String(describing: weatherItem.windItem.degree!)
        
        cloudiness.text = String(describing: weatherItem.cloudiness!)
        rainy.text = weatherItem.rainVolume != nil ? String(describing: weatherItem.rainVolume!) : "-"
        snow.text = weatherItem.snowVolume != nil ? String(describing: weatherItem.snowVolume!)  : "-"
        
    }
}
