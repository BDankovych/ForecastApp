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

    @IBOutlet weak var locationsTableView: RoundedTableView!
    
    private var test = [PlaceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        locationsTableView.register(cellType: LocationTableViewCell.self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        test = LocationsStorageManager.getList()
        locationsTableView.reloadData()
    }

    @IBAction func findButtonPressed(_ sender: UIButton) {
        present(placePickerController, animated: true, completion: nil)
    }
    

}
extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return LocationTableViewCell.cellHeight
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(cellType: LocationTableViewCell.self)
        
        cell.configureView(with: test[indexPath.row])
        return cell
        
    }
    
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        LocationsStorageManager.add(PlaceModel(place))
        dismiss(animated: true, completion: nil)
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
