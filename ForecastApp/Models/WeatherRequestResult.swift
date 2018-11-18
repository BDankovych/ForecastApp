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
}
