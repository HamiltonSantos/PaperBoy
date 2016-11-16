//
//  GameSceneRendererDelegate.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 8/21/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit
import SceneKit

class GameSceneRendererDelegate: NSObject, SCNSceneRendererDelegate {
    
    var motionManager: CMMotionManager
    let gameScene = SPScene.sharedInstance
    static let sharedInstance = GameSceneRendererDelegate()
    
    override init() {
        motionManager = CMMotionManager()
        super.init()
        initCamera()
    }
    
    func initCamera() {
        // Respond to user head movement
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 60
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical)
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) {
            (motion: CMDeviceMotion?, error) in
            
            if let motion = motion {
                let currentAttitude = motion.attitude
                let cameraNode = self.gameScene.cameraNode
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.05
                
                cameraNode!.eulerAngles.x = Float(currentAttitude.roll - 1.57)
                cameraNode!.eulerAngles.z = Float(currentAttitude.pitch)
                cameraNode!.eulerAngles.y = Float(currentAttitude.yaw)
                cameraNode?.position.z = cameraNode!.position.z - 0.1
                
                SCNTransaction.commit()
            }
            
        }
    }
    
    func renderer(_ aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0
        
        SCNTransaction.commit()
    }
    
}