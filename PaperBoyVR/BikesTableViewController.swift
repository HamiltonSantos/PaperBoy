//
//  BikesTableViewController.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 10/7/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import CoreBluetooth

class BikesTableViewController: UITableViewController {
    
    var sensors = [CadenceSensor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btManagerSharedInstance.bluetoothListDelegate = self
        btManagerSharedInstance.startScan()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sensors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bikeCell", for: indexPath) as! BikeTableViewCell
        
        cell.nameLabel.text = self.sensors[indexPath.row].peripheral.name
        cell.stateLabel.text = "\(self.sensors[indexPath.row].peripheral.state)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.sensors.count < 1 {
            return "Searching"
        } else {
            return "Found Sensors"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sensor = self.sensors[indexPath.row]
        btManagerSharedInstance.connectToSensor(sensor)
        // Save the sensor ID
        UserDefaults.standard.set(sensor.peripheral.identifier.uuidString, forKey: Constants.SensorUserDefaultsKey)
        UserDefaults.standard.synchronize()
    }
}

extension BikesTableViewController : BluetoothSensorListDelegate {
    func sensorDiscovered(_ sensor: CadenceSensor) {
        self.sensors = btManagerSharedInstance.sensors
        self.tableView.reloadData()
    }
}

