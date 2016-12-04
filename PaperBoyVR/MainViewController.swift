//
//  MainViewController.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 30/10/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import CoreBluetooth

struct Constants {
    
    static let ScanSegue = "ScanSegue"
    static let SensorUserDefaultsKey = "lastsensorused"
}

class MainViewController: TransparentNavBarViewController {

    @IBOutlet weak var connectToBikeButton: UIButton!
    @IBOutlet weak var currentSensorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         btManagerSharedInstance.bluetoothDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterMultiplayerTouchUpInside(_ sender: Any) {
        let nameAlert = UIAlertController(title: "What's your nickname?", message: "enter your multiplayer nickname", preferredStyle: UIAlertControllerStyle.alert)
        
        nameAlert.addTextField { (textField) in
            textField.placeholder = "example123"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            let nameTextField = nameAlert.textFields?.first
            if nameTextField?.text != "" {
                User.sharedInstance.name = nameTextField?.text
                self.performSegue(withIdentifier: "multiplayerSegue", sender: self)
            }
        })
        
        nameAlert.addAction(okAction)
        
        self.present(nameAlert, animated: true, completion: nil)

    }
}

extension MainViewController: BluetoothManagerDelegate {
    
    func stateChanged(_ state: CBCentralManagerState) {
        print("State Changed: \(state)")
        var enabled = false
        var title = ""
        switch state {
        case .poweredOn:
            title = "Bluetooth ON"
            enabled = true
            // When the bluetooth changes to ON, try to reconnect to the previous sensor
            checkPreviousSensor()
            
        case .resetting:
            title = "Reseeting"
        case .poweredOff:
            title = "Bluetooth Off"
        case .unauthorized:
            title = "Bluetooth not authorized"
        case .unknown:
            title = "Unknown"
        case .unsupported:
            title = "Bluetooth not supported"
        }
        //        infoViewController?.showBluetoothStatusText( title )
                connectToBikeButton.isEnabled = enabled
    }
    
    
    
    func sensorConnection( _ sensor:CadenceSensor, error:NSError?) {
        
    }
    
    func sensorDisconnected( _ sensor:CadenceSensor, error:NSError?) {
        
    }
    
    func sensorDiscovered( _ sensor:CadenceSensor ) {
        
    }
    
    func checkPreviousSensor() {
        self.currentSensorLabel.text = "No sensor connected"
        guard let sensorID = UserDefaults.standard.object(forKey: Constants.SensorUserDefaultsKey)  as? String else {
            return
        }
        guard let sensor = btManagerSharedInstance.retrieveSensorWithIdentifier(sensorID) else {
            return
        }
        self.currentSensorLabel.text = "connected to \(sensor.peripheral.name!)-\(sensor.peripheral.identifier)"
        btManagerSharedInstance.sensor = sensor
        btManagerSharedInstance.connectToSensor(sensor)
        
    }
    
}
