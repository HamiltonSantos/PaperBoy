//
//  BTService.swift
//  Arduino_Servo
//
//  Created by Owen L Brown on 10/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import CoreBluetooth

/* Services & Characteristics UUIDs */
let bLEServiceUUID = CBUUID(string: "1816")
let wheelRevolutionCharUUID = CBUUID(string: "2A5B")
let bLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"
let updatedSpeedNotification = "kUpdatedSpeed"
let myDevice:String? = nil// "71165497-6DF9-4501-97A6-53B8F2092E28" 
                          // "71165497-6DF9-4501-97A6-53B8F2092E28"
var speedCharacteristic: CBCharacteristic?

class BTService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    
    init(initWithPeripheral peripheral: CBPeripheral) {
        super.init()
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
    }
    
    deinit {
        self.reset()
    }
    
    func startDiscoveringServices() {
        self.peripheral?.discoverServices([bLEServiceUUID])
    }
    
    func reset() {
        if peripheral != nil {
            peripheral = nil
        }
        
        // Deallocating therefore send notification
        self.sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: false)
    }
    
    // Mark: - CBPeripheralDelegate
    
    func  peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        let uuidsForBTService: [CBUUID] = [wheelRevolutionCharUUID]
        
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            // No Services
            return
        }
        
        for service in peripheral.services! {
            if service.uuid == bLEServiceUUID {
                peripheral.discoverCharacteristics(uuidsForBTService, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == wheelRevolutionCharUUID {
                    speedCharacteristic = (characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                    // Send notification that Bluetooth is connected and all required characteristics are discovered
                    self.sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: true)
                }
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == wheelRevolutionCharUUID {
            NSLog("new value: \(characteristic.value?[1])")
            self.sendBTServiceNotificationWithUpdatedSpeed(newSpeed: Double((characteristic.value?[1])!) )
        }
    }
    
    // Mark: - Private
    
    func sendBTServiceNotificationWithUpdatedSpeed(newSpeed: Double) {
        let speedInfoDictionary = ["speed": newSpeed]
        NotificationCenter.default.post(name:Notification.Name(updatedSpeedNotification), object: self, userInfo: speedInfoDictionary)
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name:Notification.Name(bLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }
    
}
