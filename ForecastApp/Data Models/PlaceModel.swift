

import UIKit
import GooglePlaces

class PlaceModel {
    var name: String!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var subtitle: String!
    
    private init() {}
    
    convenience init(_ place: GMSPlace) {
        self.init()
        name = place.name
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        subtitle = place.formattedAddress
    }
}
