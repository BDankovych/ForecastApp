//
//  SettingsViewController.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/19/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    
    
    @IBOutlet weak var temperatureSegmentControl: UISegmentedControl!
    @IBOutlet weak var speedSegmentControl: UISegmentedControl!
    @IBOutlet weak var languagesPicker: UIPickerView!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagesPicker.delegate = self
        languagesPicker.dataSource = self
        speedSegmentControl.selectedSegmentIndex = SettingsManager.speedUnits.rawValue
        temperatureSegmentControl.selectedSegmentIndex = SettingsManager.tempUnits.rawValue
        
    }
    override func viewDidAppear(_ animated: Bool) {
        localizeView()
        languagesPicker.selectRow(SettingsManager.currentLanguage.rawValue, inComponent: 0, animated: false)
    }
    
    @IBAction func speedSegmentValueChanged(_ sender: Any) {
        SettingsManager.setSpeedUnits(SpeedUnits(rawValue: speedSegmentControl.selectedSegmentIndex) ?? .mpsec)
    }
    
    @IBAction func tempSegmentValueChanged(_ sender: Any) {
        SettingsManager.setTempUnits(TemperatureUnits(rawValue: temperatureSegmentControl.selectedSegmentIndex) ?? .celsius)
    }
    

    @IBAction func backPressed() {
        dismiss(animated: true)
    }
    
    override func localizeView() {
        super.localizeView()
        speedLabel.text = "Speed".localized()
        temperatureLabel.text = "Temperature".localized()
        languageLabel.text = "Language".localized()
        settingsLabel.text = "Settings".localized()
    }
    
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Languages.getAll().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Languages.getAll()[row].getText()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SettingsManager.setLanguage(Languages(rawValue: row) ?? .en)
        localizeView()
    }
    
}
