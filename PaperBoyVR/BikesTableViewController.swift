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
    
    var bikes = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bikes = btDiscoverySharedInstance.peripherals
        
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
        return self.bikes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bikeCell", for: indexPath) as! BikeTableViewCell
        
        cell.nameLabel.text = self.bikes[indexPath.row].name
        cell.stateLabel.text = "\(self.bikes[indexPath.row].state)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.bikes.count < 1 {
            return "Searching"
        } else {
            return "Found Sensors"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btDiscoverySharedInstance.connectPeripheral(peripheral: self.bikes[indexPath.row])
    }
    
}
