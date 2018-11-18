//
//  Int.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import Foundation

extension Int {
    func isSuccessCode() -> Bool {
        return self / 100 == 2
    }
}
