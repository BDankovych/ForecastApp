//
//  LocationTableViewCell.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    static var identifier = "LocationTableViewCellID"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    static let cellHeight: CGFloat = 80.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(with placeModel: PlaceModel) {
        nameLabel.text = placeModel.name
        subtitleLabel.text = placeModel.subtitle
    }
    
}
