//
//  ViewController.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: BaseViewController {
    
    private lazy var placePickerController: GMSAutocompleteViewController = {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        placePickerController.autocompleteFilter = filter
        return placePickerController
    }()

    private var locationManager = CLLocationManager()
    
    @IBOutlet weak var locationsTableView: RoundedTableView!
    
    private var locationsList = [PlaceModel]() {
        didSet {
            locationsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationsStorageManager.addStorageObserver(self)
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationsTableView.reloadData()
    }

    @IBAction func findButtonPressed(_ sender: UIButton) {
        present(placePickerController, animated: true, completion: nil)
    }
    
    private func goToDetailInfo(with place: PlaceModel) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: WeatherDetailViewController.identifier) as? WeatherDetailViewController else {
            fatalError()
        }
        detailVC.place = place
        present(detailVC, animated: true, completion: nil)
    }
    
    func currentLocationAllowed() {
        self.startActivityIndicator()
        self.getCurrentPlace { (placeModel, error) in
            if let error = error {
                self.showErrorPopup(text: error.localizedDescription)
            } else {
                LocationsStorageManager.addCurrentLocation(placeModel!)
            }
            LocationsStorageManager.loadLocations()
            self.stopActivityIndicator()
        }
    }
    
    func getCurrentPlace(_ completion:@escaping (PlaceModel?, Error?) -> Void ) {
        let placeClient = GMSPlacesClient()
        placeClient.currentPlace { (placeList, error) in
            guard let place = placeList?.likelihoods.first?.place, error == nil else {
                completion(nil, error)
                return
            }
            let placeModel = PlaceModel(place)
            placeModel.name = "Current location".localized()
            placeModel.subtitle = ""
            completion(placeModel, nil)
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            currentLocationAllowed()
            break
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       goToDetailInfo(with: locationsList[indexPath.row])
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier) as! LocationTableViewCell
        
        cell.configureView(with: locationsList[indexPath.row])
        return cell
        
    }
    
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let placeModel = PlaceModel(place)
        dismiss(animated: true) {
            self.goToDetailInfo(with: placeModel)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        showErrorPopup(text: error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


extension ViewController: LocationsStorageManagerObserver {
    func didChangeList(_ list: [PlaceModel]) {
        locationsList = list
    }
}
