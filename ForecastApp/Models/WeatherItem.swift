//
//  WeatherItem.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import ObjectMapper

class ShortWeatherItem: Mappable {
    var id: Int!
    var main: String!
    var descroption: String!
    var iconText: String!
    
    
    private enum JSONKeys: String {
        case id = "id"
        case main = "main"
        case description = "description"
        case iconText = "icon"
    }
    
    required init?(map: Map) {
        if map.JSON[JSONKeys.id.rawValue] == nil ||
            map.JSON[JSONKeys.main.rawValue] == nil ||
            map.JSON[JSONKeys.description.rawValue] == nil ||
            map.JSON[JSONKeys.iconText.rawValue] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map[JSONKeys.id.rawValue]
        main <- map[JSONKeys.main.rawValue]
        descroption <- map[JSONKeys.description.rawValue]
        iconText <- map[JSONKeys.iconText.rawValue]
    }
    
}

class WindWeatherItem: Mappable {
    
    var speed: Double!
    var degree: Double!
    
    
    private enum JSONKeys: String {
        case speed = "speed"
        case degree = "deg"
    }
    
    required init?(map: Map) {
        if map.JSON[JSONKeys.speed.rawValue] == nil ||
            map.JSON[JSONKeys.degree.rawValue] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        speed <- map[JSONKeys.speed.rawValue]
        degree <- map[JSONKeys.degree.rawValue]
    }
}


class MainWeatherItem: Mappable {
    
    var temp: Double!
    var minTemp: Double!
    var maxTemp: Double!
    var pressure: Double!
    var humidity: Double!
    
    private enum JSONKeys: String {
        case temp = "temp"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    required init?(map: Map) {
        if map.JSON[JSONKeys.temp.rawValue] == nil ||
            map.JSON[JSONKeys.minTemp.rawValue] == nil ||
            map.JSON[JSONKeys.maxTemp.rawValue] == nil ||
            map.JSON[JSONKeys.pressure.rawValue] == nil ||
            map.JSON[JSONKeys.humidity.rawValue] == nil {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        temp <- map[JSONKeys.temp.rawValue]
        minTemp <- map[JSONKeys.minTemp.rawValue]
        maxTemp <- map[JSONKeys.maxTemp.rawValue]
        pressure <- map[JSONKeys.pressure.rawValue]
        humidity <- map[JSONKeys.humidity.rawValue]
    }
}

class WeatherItem: Mappable {
    
    var forecastDate: Date!
    //TODO: add time zone 
    var forecastTimeInterval: Int! {
        didSet {
            forecastDate = Date(timeIntervalSince1970: TimeInterval(forecastTimeInterval));
        }
    }
    var mainItem: MainWeatherItem!
    var shortWeatherItems: [ShortWeatherItem]!
    var cloudiness: Int!
    var windItem: WindWeatherItem!
    var rainVolume: Double?
    var snowVolume: Double?
    
    private enum JSONKeys: String {
        case forecastTimeInterval = "dt"
        case mainItem = "main"
        case shortWeatherItem = "weather"
        case cloudiness = "clouds.all"
        case windItem = "wind"
        case rainVolume = "rain.3h"
        case snowVolume = "snow.3h"
    }
    
    required init?(map: Map) {
        if map.JSON[JSONKeys.forecastTimeInterval.rawValue] == nil ||
            map.JSON[JSONKeys.mainItem.rawValue] == nil ||
            map.JSON[JSONKeys.shortWeatherItem.rawValue] == nil ||
            map.JSON[JSONKeys.windItem.rawValue] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        shortWeatherItems <- map[JSONKeys.shortWeatherItem.rawValue]
        forecastTimeInterval <- map[JSONKeys.forecastTimeInterval.rawValue]
        mainItem <- map[JSONKeys.mainItem.rawValue]
        cloudiness <- map[JSONKeys.cloudiness.rawValue]
        windItem <- map[JSONKeys.windItem.rawValue]
        rainVolume <- map[JSONKeys.rainVolume.rawValue]
        snowVolume <- map[JSONKeys.snowVolume.rawValue]
    }
    
    
}
