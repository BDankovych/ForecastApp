//
//  WeatherCollectionViewCell.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit

enum ForecastMode {
    case daily
    case hourly
}

class WeatherCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windArrow: UIImageView!
    @IBOutlet weak var cloudiness: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rainy: UILabel!
    @IBOutlet weak var snow: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    
    
    func configure(with weatherItem: WeatherItem, mode: ForecastMode, timeZone: TimeZone ) {
        let formatter = DateFormatter()
        if mode == .hourly {
            formatter.dateFormat = "dd.MM \n hh a"
        } else {
            formatter.dateFormat = "dd.MM"
        }
        formatter.timeZone = timeZone
        timeLabel.text = formatter.string(from: weatherItem.forecastDate)
        weatherIcon.image = weatherItem.shortWeatherItems.first!.iconText.image
        temp.text = String(describing: weatherItem.mainItem.temp!.rounded(toPlaces: 2))
        minTemp.text = String(describing: weatherItem.mainItem.minTemp!.rounded(toPlaces: 2))
        maxTemp.text = String(describing: weatherItem.mainItem.maxTemp!.rounded(toPlaces: 2))
        pressure.text = String(describing: weatherItem.mainItem.pressure!.rounded(toPlaces: 2))
        humidity.text = String(describing: weatherItem.mainItem.humidity!.rounded(toPlaces: 2))
        
        windSpeed.text = String(describing: weatherItem.windItem.speed!.rounded(toPlaces: 2))
        windArrow.transform = windArrow.transform.rotated(by: CGFloat(weatherItem.windItem.degree!.degreesToRadians.rounded(toPlaces: 2)))
        
        cloudiness.text = String(describing: weatherItem.cloudiness!)
        rainy.text = weatherItem.rainVolume != nil ? String(describing: weatherItem.rainVolume!.rounded(toPlaces: 2)) : "-"
        snow.text = weatherItem.snowVolume != nil ? String(describing: weatherItem.snowVolume!.rounded(toPlaces: 2))  : "-"
        
    }
}
