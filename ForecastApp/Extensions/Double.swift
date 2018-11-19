//
//  Double.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/19/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var degreesToRadians: Double {
        return self * .pi / 180
    }
}
