//
//  WeatherDetailViewController.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit
import LatLongToTimezone
import CoreLocation


fileprivate enum Direction {
    case up
    case down
    
    mutating func toggle() {
        if self == .up {
            self = .down
        } else {
            self = .up
        }
    }
}



class WeatherDetailViewController: BaseViewController {
    
    static let identifier = "WeatherDetailViewControllerID"
    
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    @IBOutlet weak var infoViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBOutlet weak var starButton: UIButton!
    
    
    
    //Mark: - Current weather
    @IBOutlet weak var locationsName: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var tempSymbol: UILabel!
    @IBOutlet weak var mainWeatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    
    //MARK: outlet for localization
    
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainylabel: UILabel!
    @IBOutlet weak var snowyLabel: UILabel!
    
 
    
    var place: PlaceModel!
    private var placeTimeZone: TimeZone!
    
    private var isInFavorites = false {
        didSet {
            DispatchQueue.main.async {
                self.starButton.imageView?.image = !self.isInFavorites ? "star".image : "starSelected".image
            }
        }
    }
    
    
    
    private var currentArrowDirection = Direction.up
    
    
    private var dataForDisplaying = [WeatherItem]()
    private var weatherRequestResult: WeatherRequestResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherCollectionView.register(cellType: WeatherCollectionViewCell.self)
        weatherCollectionView.dataSource = self
        
    }
    
    override func localizeView() {
        super.localizeView()
        minTemp.text = "Minimum temperature, ".localized() + SettingsManager.tempUnits.getSymbol()
        maxTemp.text = "Maximum temperature, ".localized() + SettingsManager.tempUnits.getSymbol()
        pressureLabel.text = "Pressure, mmbar".localized()
        windSpeedLabel.text = "Wind speed, ".localized() + SettingsManager.speedUnits.getSymbol()
        cloudinessLabel.text = "Cloudiness".localized()
        humidityLabel.text = "Humidity, %".localized()
        rainylabel.text = "rainy".localized()
        snowyLabel.text = "snowy".localized()
        
        segmentControll.setTitle("Hourly".localized(), forSegmentAt: 0)
        segmentControll.setTitle("Daily".localized(), forSegmentAt: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startActivityIndicator()
        localizeView()
        configureView(with: place)
        ForecastAPIManager.loadAdditionalInfo(for: place) { (success, weatherResult, error) in
            self.stopActivityIndicator()
            if success {
                self.configureView(with: weatherResult!.list.first!)
                self.configureView(with: weatherResult!)
            } else {
                self.showErrorPopup(text: error?.localizedDescription ?? "Undefined error") {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func configureView(with place: PlaceModel) {
        if place.name != "Current location".localized() {
            starButton.isHidden = false
            isInFavorites = LocationsStorageManager.isInFavorites(place: place)
        } else {
            starButton.isHidden = true
        }
        locationsName.text = place.name
        tempSymbol.text = SettingsManager.tempUnits.getSymbol()
        placeTimeZone = TimezoneMapper.latLngToTimezone(CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
    }
    
    private func configureView(with weatherItem: WeatherItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        formatter.timeZone = placeTimeZone
        currentDate.text = formatter.string(from: weatherItem.forecastDate)
        currentTemp.text = String(describing: weatherItem.mainItem.temp!)
        mainWeatherLabel.text = weatherItem.shortWeatherItems.first!.main
        weatherDescriptionLabel.text = weatherItem.shortWeatherItems.first!.descroption
        backgroundImage.image = (weatherItem.shortWeatherItems.first!.iconText + "BG").image
    }
    
    private func configureView(with weatherResult: WeatherRequestResult) {
        weatherRequestResult = weatherResult
        if segmentControll.selectedSegmentIndex == 0 {
            setupWeatherHourly(with: weatherResult)
        } else {
            setupWeatherDaily(with: weatherResult)
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if segmentControll.selectedSegmentIndex == 0 {
            setupWeatherHourly(with: weatherRequestResult)
        } else {
            setupWeatherDaily(with: weatherRequestResult)
        }
    }
    
    
    private func setupWeatherHourly(with weatherResult: WeatherRequestResult) {
        dataForDisplaying = weatherResult.getHourlyList()
        weatherCollectionView.reloadData()
    }
    
    private func setupWeatherDaily(with weatherResult: WeatherRequestResult) {
        dataForDisplaying = weatherResult.getDailyList()
        weatherCollectionView.reloadData()
    }
    
    
    @IBAction func starButtonPressed(_ sender: Any) {
        
        if !isInFavorites {
            LocationsStorageManager.addToFavorites(place)
            isInFavorites = true
        } else {
            LocationsStorageManager.removeFromFavorites(place)
            isInFavorites = false
        }
    }
    
    @IBAction func infoBlockSwippedUp(_ sender: UISwipeGestureRecognizer) {
        if currentArrowDirection == .up {
            currentArrowDirection.toggle()
            updateInfoBlock(direction: .up)
        }
    }
    
    @IBAction func infoBlockSippedDown(_ sender: UISwipeGestureRecognizer) {
        if currentArrowDirection == .down {
            currentArrowDirection.toggle()
            updateInfoBlock(direction: .down)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func updateInfoBlock(direction: Direction) {
        var topConstant: CGFloat!
        
        if direction == .up {
            topConstant = -300
        } else {
            topConstant = 0
        }
        
        infoViewTopConstraint.constant = topConstant
        UIView.animate(withDuration: 0.5) {
            self.arrowImage.transform = self.arrowImage.transform.rotated(by: .pi)
            self.view.layoutIfNeeded()
        }
    }
}

extension WeatherDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataForDisplaying.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(cellType: WeatherCollectionViewCell.self, for: indexPath)
        cell.configure(with: dataForDisplaying[indexPath.row], mode: segmentControll.selectedSegmentIndex == 0 ? .hourly : .daily, timeZone: placeTimeZone )
        return cell
    }
    
    
}
