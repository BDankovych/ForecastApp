//
//  WeatherRequestResult.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import ObjectMapper

class WeatherRequestResult: Mappable {
    
    var message: String?
    var list: [WeatherItem]!
    
    private enum JSONKeys: String {
        case message = "message"
        case list = "list"
    }
    
    required init?(map: Map) {
        
        if map.JSON[JSONKeys.list.rawValue] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        list <- map[JSONKeys.list.rawValue]
        message <- map[JSONKeys.message.rawValue]
    }
    
    func getHourlyList() -> [WeatherItem] {
        return list.sorted{ return $0.forecastDate < $1.forecastDate}
    }
    
    func getDailyList() -> [WeatherItem] {
        
        var resultList = [list.first!]
        var itemsCount = 0
        
        for index in 1..<list.count {
            let itemDay = Calendar.current.component(.day, from: list[index].forecastDate)
            let currentDay = Calendar.current.component(.day, from: resultList.last!.forecastDate)
            if itemDay == currentDay {
                itemsCount += 1
                resultList.last!.mainItem.temp += list[index].mainItem.temp
                resultList.last!.mainItem.pressure += list[index].mainItem.pressure
                resultList.last!.mainItem.humidity += list[index].mainItem.humidity
                
                resultList.last!.windItem.speed += list[index].windItem.speed
                resultList.last!.windItem.degree += list[index].windItem.degree
                
                resultList.last!.cloudiness += list[index].cloudiness
                
                if resultList.last!.mainItem.minTemp > list[index].mainItem.minTemp {
                    resultList.last!.mainItem.minTemp = list[index].mainItem.minTemp
                }
                
                if resultList.last!.mainItem.maxTemp < list[index].mainItem.maxTemp {
                    resultList.last!.mainItem.maxTemp = list[index].mainItem.maxTemp
                }
                //TODO: think about icon
            } else {
                
                resultList.last!.mainItem.temp /= Double(itemsCount)
                resultList.last!.mainItem.pressure /= Double(itemsCount)
                resultList.last!.mainItem.humidity /= Double(itemsCount)
                
                resultList.last!.windItem.speed /= Double(itemsCount)
                resultList.last!.windItem.degree /= Double(itemsCount)
                
                resultList.last!.cloudiness /= itemsCount
                
                itemsCount = 0
                resultList.append(list[index])
            }
        }
        
        
        
        return resultList
    }
}
