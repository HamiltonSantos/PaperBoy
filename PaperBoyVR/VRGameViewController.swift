//
//  VRGameViewController.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 9/18/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import WatchConnectivity

class VRGameViewController: TransparentNavBarViewController {
    
    let gameController = SPController()
    var accumulatedDistance:Double?
    
    @IBOutlet weak var sceneViewLeft: GameSceneView!
    @IBOutlet weak var sceneViewRight: GameSceneView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var cadenceLabel: UILabel!
    @IBOutlet weak var crosshairSizeConstraint: NSLayoutConstraint!
    let initialCrosshairSize:CGFloat = 50.0
    
    lazy var distanceFormatter:LengthFormatter = {
        
        let formatter = LengthFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SPScene.sharedInstance.sharedScene.isPaused = false
        
        gameController.viewControllerDelegate = self
        
        gameController.playMusic()
        
        GameSceneRendererDelegate.sharedInstance.crosshairDelegate = self
        
        btManagerSharedInstance.sensor?.sensorDelegate = self
        
        
    }
    
    func throwNewspaper() {
        self.gameController.throwNewspaper()
        resizeCrosshair(size: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SPScene.sharedInstance.paperBoyNode.position.z = 24
        SPScene.sharedInstance.sharedScene.isPaused = true
    }
    
}

extension VRGameViewController : CadenceSensorDelegate {
    
    func errorDiscoveringSensorInformation(_ error: NSError) {
        print("An error ocurred disconvering the sensor services/characteristics: \(error)")
    }
    
    func sensorReady() {
        print("Sensor ready to go...")
        accumulatedDistance = 0.0
    }
    
    func sensorUpdatedValues( speedInMetersPerSecond speed:Double?, cadenceInRpm cadence:Double?, distanceInMeters distance:Double? ) {
        
        accumulatedDistance? += distance ?? 0
        let distanceText = (accumulatedDistance != nil && accumulatedDistance! >= 1.0) ? distanceFormatter.string(fromMeters: accumulatedDistance!) : "N/A"
        let speedText = (speed != nil) ? distanceFormatter.string(fromValue: speed!*3.6, unit: .kilometer) : "N/A"
        let cadenceText = (cadence != nil) ? String(format: "%.0f",  cadence!) : "N/A"
        
        distanceLabel.text = distanceText
        cadenceLabel.text = cadenceText
        speedLabel.text = speedText
        
        GameSceneRendererDelegate.sharedInstance.currentSpeed = cadence ?? 0
    }
}

extension VRGameViewController: CrosshairDelegate {
    func resizeCrosshair(size: CGFloat) {
        if size > 0.2 {
            DispatchQueue.main.async {
                self.crosshairSizeConstraint.constant = size*self.initialCrosshairSize
            }
        }
    }
    
    func throwNewspaperAction () {
        self.throwNewspaper()
    }
}
