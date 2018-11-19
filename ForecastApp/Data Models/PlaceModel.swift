

import UIKit
import GooglePlaces

class PlaceModel {
    var name: String!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var subtitle: String!
    
    private init() {}
    
    convenience init(name: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        self.init()
        self.name = name
        self.latitude = lat
        self.longitude = long
        self.subtitle = ""
    }
    
    convenience init(_ place: GMSPlace) {
        self.init()
        name = place.name
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        subtitle = place.formattedAddress
    }
    
    convenience init(_ mo: PlaceModelMO) {
        self.init()
        name = mo.name
        latitude = mo.latitude
        longitude = mo.longitude
        subtitle = mo.subtitle
    }
    
}

func == ( _ first: PlaceModel, _ second: PlaceModel) -> Bool {
    let offset: CLLocationDegrees = 0.01
    return first.name == second.name &&
        abs(first.latitude - second.latitude) < offset &&
        abs(first.longitude - second.longitude) < offset
}

func == ( _ first: PlaceModel, _ second: PlaceModelMO) -> Bool {
    let secondPlace = PlaceModel(second)
    return first == secondPlace
}
