//
//  String+Localization.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/19/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "ForecastAppLocalizable" + SettingsManager.currentLanguage.symbol, comment: self)
    }
}
