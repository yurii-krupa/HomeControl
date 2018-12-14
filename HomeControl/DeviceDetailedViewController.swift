//
//  DeviceDetailedViewController.swift
//  HomeControl
//
//  Created by Yurii Krupa on 12/12/18.
//  Copyright © 2018 Yurii Krupa. All rights reserved.
//

import UIKit

class DeviceDetailedViewController: UIViewController {

    @IBOutlet weak var activeStatusLabel: UILabel!
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var relaySwitch: UISwitch!
    @IBAction func relaySwitchStateChange(_ sender: Any) {
        print(self.relaySwitch.isOn)
    }
    
    var currentDevice: Device! {
        didSet {
            self.view.layoutIfNeeded()
            self.activeStatusLabel.text = currentDevice.isActive == true ? "Status: Active" : "Status: Disabled"
            self.deviceNameTextField.text = currentDevice.name
            self.temperatureLabel.text = String(currentDevice.currentTemperature)
            self.humidityLabel.text = String(currentDevice.currentHumidity)
            self.relaySwitch.isOn = currentDevice.isSwitchedOn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editDevice))
        let updateBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshDevice))
        self.navigationItem.rightBarButtonItems = [editBarButton, updateBarButton]

        // Do any additional setup after loading the view.
    }
    
    @objc private func editDevice() {
        deviceNameTextField.isEnabled = !deviceNameTextField.isEnabled
    }
    @objc private func refreshDevice() {
        print("refreshed")
        
    }
    
}
