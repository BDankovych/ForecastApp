

import UIKit

protocol LocationsStorageManagerObserver: class {
    func didChangeList(_ list: [PlaceModel])
}

class LocationsStorageManager: NSObject {
    private static var instance = LocationsStorageManager()
    
    private var observers = [LocationsStorageManagerObserver]()
    
    private var placesList = [PlaceModel]() {
        didSet {
            for observer in observers {
                observer.didChangeList(placesList)
            }
        }
    }
    
    static func addStorageObserver(_ observer: LocationsStorageManagerObserver ) {
        instance.observers.append(observer)
        observer.didChangeList(instance.placesList)
    }
    
    static func addCurrentLocation(_ place: PlaceModel) {
        instance.placesList = [place]
    }
    static func loadLocations() {
        instance.placesList += CoreDataService.loadAllLocations()
    }
    
    static func getList() -> [PlaceModel] {
        return instance.placesList
    }
    
    static func addToFavorites(_ place: PlaceModel ) {
        instance.placesList.append(place)
        CoreDataService.addLocation(place)
    }
    
    static func removeFromFavorites(_ place: PlaceModel) {
        for index in 0..<instance.placesList.count where instance.placesList[index] == place {
            CoreDataService.removeLocation(place)
            instance.placesList.remove(at: index)
            return
        }
    }
    
    static func isInFavorites(place: PlaceModel) -> Bool {
        
        for item in instance.placesList {
            if item == place {
                return true
            }
        }
        return false
    }
    
}
