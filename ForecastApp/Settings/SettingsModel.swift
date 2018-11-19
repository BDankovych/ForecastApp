//
//  SettingsModel.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/19/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//
import Foundation

enum Languages: Int {
    case en = 0
    case ua = 1
    
    func getText() -> String {
        switch self {
        case .en:
            return "English"
        case .ua:
            return "Українська"
        }
    }
    
    var symbol: String {
        switch self {
        case .en:
            return "EN"
        case .ua:
            return "UA"
        }
    }
    
    
    static func getAll() -> [Languages] {
        return [.en, .ua]
    }
}

enum TemperatureUnits: Int {
    case celsius = 0
    case farengate = 1
    
    func getSymbol() -> String {
        switch self {
        case .celsius:
            return "℃"
        case .farengate:
            return "℉"
        }
    }
    
    var uniysDescription: String {
        switch self {
        case .celsius:
            return "metric"
        case .farengate:
            return "imperial"
        }
    }
}

enum SpeedUnits: Int {
    case mpsec = 0
    case mph = 1
    
    func getSymbol() -> String {
        switch self {
        case .mpsec:
            return "m/sec"
        case .mph:
            return "mph"
        }
    }
}

class SettingsModel {

    var currentLanguage: Languages!
    var tempUnits: TemperatureUnits!
    var speedUnits: SpeedUnits!
    
    private init() {}
    
    convenience init(_ mo: SettingsStorageMO) {
        self.init()
        currentLanguage = Languages(rawValue: Int(mo.currentLanguage))!
        tempUnits = TemperatureUnits(rawValue: Int(mo.tempUnits))!
        speedUnits = SpeedUnits(rawValue: Int(mo.speedUnits))!
    }
    
}
