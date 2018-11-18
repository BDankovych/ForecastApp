//
//  WeatherDetailViewController.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit

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
    
    
    var place: PlaceModel!
    
    
    private var currentArrowDirection = Direction.up
    
    //Data
    
    private var dataForDisplaying = [WeatherItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherCollectionView.register(cellType: WeatherCollectionViewCell.self)
        weatherCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startActivityIndicator()
        ForecastAPIManager.loadAdditionalInfo(for: place) { (success, weatherResult, error) in
            self.stopActivityIndicator()
            if success {
                self.configureView(with: weatherResult!)
            } else {
                self.showErrorPopup(text: error?.localizedDescription ?? "Undefined error") {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func configureView(with weatherResult: WeatherRequestResult) {
        if segmentControll.selectedSegmentIndex == 0 {
            setupWeatherHourly(with: weatherResult)
        } else {
            setupWeatherDayly(with: weatherResult)
        }
    }
    
    private func setupWeatherHourly(with weatherResult: WeatherRequestResult) {
        dataForDisplaying = weatherResult.list.sorted{ return $0.forecastDate < $1.forecastDate}
        weatherCollectionView.reloadData()
    }
    
    private func setupWeatherDayly(with weatherResult: WeatherRequestResult) {
        
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
        cell.configure(with: dataForDisplaying[indexPath.row], mode: .dayly)
        return cell
    }
    
    
}
