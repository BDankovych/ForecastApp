//
//  ForecastAPIManager.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit
import Alamofire


class ForecastAPIManager: NSObject {
    
    private static let APPID = "e386d7634c474af98009c8704f337845"
    
    static func loadAdditionalInfo(for place: PlaceModel, completion: @escaping (Bool, WeatherRequestResult?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "api.openweathermap.org"
        let path = "/data/2.5/forecast"
        let latItem = URLQueryItem(name: "lat", value: "\(place.latitude!)")
        let longItem = URLQueryItem(name: "lon", value: "\(place.longitude!)")
        let unitsItem = URLQueryItem(name: "units", value: "metric")
        let appidItem = URLQueryItem(name: "APPID", value: APPID)
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [latItem, longItem, unitsItem, appidItem]
        
        let url = urlComponents.url!
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseString { (dataResponse) in
            guard dataResponse.response?.statusCode.isSuccessCode() == true,
                let jsonString = dataResponse.result.value,
                let weatherResult = WeatherRequestResult(JSONString: jsonString) else {
                    completion(false, nil, dataResponse.error)
                    return
            }
            
            completion(true, weatherResult, nil)
        }
    }
    
}
