//
//  ViewController.swift
//  HomeControl
//
//  Created by Yurii Krupa on 12/12/18.
//  Copyright © 2018 Yurii Krupa. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var devicesTableView: UITableView!
    
    var databaseRef: DatabaseReference!
    let deviceID = "DeviceID"
    var devices = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.databaseRef = Database.database().reference()
//        self.databaseRef.child("Devices").child(deviceID).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            guard let device = NetworkManager.parseDeviceFrom(snapshot: snapshot) else { return }
//            self.devices.append(device)
//            self.devicesTableView.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
//        self.databaseRef.child("Devices").observeSingleEvent(of: .value, with: { (snapshot) in
//            self.devices = NetworkManager.parseDevicesFrom(snapshot: snapshot)
//            self.devicesTableView.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        self.refreshTableView()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshTableView))
        self.navigationItem.rightBarButtonItems = [addBarButton, refreshButton]
    }

    override func viewDidAppear(_ animated: Bool) {
        self.refreshTableView()
    }
    
    func snowDeviceDetailedViewController(device: Device) {
        guard let deviceDetailedViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeviceDetailedViewController") as? DeviceDetailedViewController else { return }
        deviceDetailedViewController.currentDevice = device
        self.navigationController?.pushViewController(deviceDetailedViewController, animated: true)
    }
    
    @objc func refreshTableView() {
        self.databaseRef.child("Devices").observeSingleEvent(of: .value, with: { (snapshot) in
            self.devices = NetworkManager.parseDevicesFrom(snapshot: snapshot)
            self.devicesTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = devices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell")!
        
        cell.textLabel?.text = item.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.snowDeviceDetailedViewController(device: devices[indexPath.row])
    }
    
    
}


class NetworkManager {
    
    // MARK: - Properties
    
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager()

        return networkManager
    }()
    
    // MARK: -
    
    let databaseRef: DatabaseReference!
    let deviceID = "DeviceID"
    var devices = [Device]()
    
    // Initialization
    
    private init() {
        self.databaseRef = Database.database().reference()
    }
    
    // MARK: - Accessors
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    func loadDevices() -> [Device] {
        self.databaseRef.child("Devices").observeSingleEvent(of: .value, with: { (snapshot) in
            self.devices = NetworkManager.parseDevicesFrom(snapshot: snapshot)
        }) { (error) in
            print(error.localizedDescription)
        }
        return devices
    }
    
    static func parseDeviceFrom(snapshot: DataSnapshot) -> Device? {
        guard let value = snapshot.value as? NSDictionary,
            let currentParameters = value["Current heating parameters"] as? [String: Any] else { return nil }
        
        return Device.init(id: snapshot.key as? String ?? "",
                           name: value["DeviceName"] as? String ?? "",
                           currentTemperature: currentParameters["Temperature-C"] as? Double ?? 0.0,
                           currentHumidity: currentParameters["Humidity-%"] as? Double ?? 0.0,
                           isActive: value["isDeviceActive"] as? Bool ?? false,
                           isSwitchedOn: value["isSwitchStateOn"] as? Bool ?? false,
                           logs: value["Logs"] as? [String: [String: Any]] ?? [String: [String: Any]]())
    }
    
    static func parseDevicesFrom(snapshot: DataSnapshot) -> [Device] {
        var devices = [Device]()
        guard let snapshot = snapshot as? DataSnapshot else { return [Device]() }
        for device in snapshot.children {
            if let device = device as? DataSnapshot {
                if let deviceStrong = NetworkManager.parseDeviceFrom(snapshot: device) {
                    devices.append(deviceStrong)
                }
            }
        }
        return devices
    }
    
    
}

struct Device {
    var id: String
    var name: String
    var currentTemperature: Double
    var currentHumidity: Double
    var isActive: Bool
    var isSwitchedOn: Bool
    var logs: [String: [String: Any]]
    
    
//    init?(dicctionary: [String: String]) {
//        guard let name = dicctionary["DeviceName"] as? String,
//        let currentParameters = dicctionary["Current heating parameters"] as? [String: Any],
//            let currentTemperature = currentParameters["Temperature-C"] as? Double,
//            let currentHumidity = currentParameters["Humidity-%"] as? Double,
//            let isActive = dicctionary["isDeviceActive"] as? Bool,
//            let isSwitchedOn = dicctionary["isSwitchStateOn"] as? Bool,
//            let logs = dicctionary["Logs"] as? [String: [String: Any]]
//            else { return nil }
//        self.name = name
//        self.currentTemperature = currentTemperature
//        self.currentHumidity = currentHumidity
//        self.isActive = isActive
//        self.isSwitchedOn = isSwitchedOn
//        self.logs = logs
//    }
    
}
