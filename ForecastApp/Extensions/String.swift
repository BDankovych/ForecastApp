//
//  String.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var image: UIImage! {
        return UIImage(named: self) ?? UIImage()
    }
}
