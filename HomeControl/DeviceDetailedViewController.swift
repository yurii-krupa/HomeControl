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
        NetworkManager.shared().databaseRef.child("/Devices/\(deviceID)/isSwitchStateOn").setValue(self.relaySwitch.isOn)
    }
    
    let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editDevice))
    let updateBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDevice))
    
    var deviceID: String = ""
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
        self.deviceID = currentDevice.id
        
        self.navigationItem.rightBarButtonItems = [editBarButton, updateBarButton]

        // Do any additional setup after loading the view.
    }
    
    @objc private func editDevice() {
        deviceNameTextField.isEnabled = !deviceNameTextField.isEnabled
        
//        NetworkManager.shared().databaseRef.child("Devices").child(deviceID).setValue(["DeviceName": self.deviceNameTextField.text!])
        NetworkManager.shared().databaseRef.child("/Devices/\(deviceID)/isSwitchStateOn").setValue(self.relaySwitch.isOn)
    }
    @objc private func refreshDevice() {
        print("refreshed")
        NetworkManager.shared().databaseRef.child("Devices").child(deviceID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let device = NetworkManager.parseDeviceFrom(snapshot: snapshot) else { return }
            self.currentDevice = device
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
