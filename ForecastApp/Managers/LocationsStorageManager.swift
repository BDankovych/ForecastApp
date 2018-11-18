

import UIKit


class LocationsStorageManager: NSObject {
    private static var instance = LocationsStorageManager()
    
    private var placesList = [PlaceModel]() {
        didSet {
            print("Hello")
        }
    }
    
    static func getList() -> [PlaceModel] {
        return instance.placesList
    }
    
    static func add(_ place: PlaceModel ) {
        instance.placesList.append(place)
    }
    
}
