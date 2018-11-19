//
//  SettingsManager.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/19/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import Foundation

class SettingsManager {
    
    private static let instance = SettingsManager()
    
    var settingsModel: SettingsModel!
    
    
    private init() {}
    
    static func loadSettings() {
        instance.settingsModel = CoreDataService.getSettings()
    }
    
    static var currentLanguage: Languages {
        return instance.settingsModel.currentLanguage
    }
    
    static var tempUnits: TemperatureUnits {
        return instance.settingsModel.tempUnits
    }
    
    static var speedUnits: SpeedUnits {
        return instance.settingsModel.speedUnits
    }
    
    static func setTempUnits(_ units: TemperatureUnits) {
        instance.settingsModel.tempUnits = units
        CoreDataService.saveSettings()
    }
    
    static func setSpeedUnits(_ units: SpeedUnits) {
        instance.settingsModel.speedUnits = units
        CoreDataService.saveSettings()
    }
    
    static func setLanguage(_ language: Languages) {
        instance.settingsModel.currentLanguage = language
        CoreDataService.saveSettings()
    }
}
