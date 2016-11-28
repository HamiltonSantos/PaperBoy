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
    var paperBoyNode:SCNNode!
    
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
                self.paperBoyNode = self.gameScene.paperBoyNode
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.05
                cameraNode!.eulerAngles.x = Float(currentAttitude.roll) - Float(M_PI/2)
                cameraNode!.eulerAngles.z = Float(currentAttitude.pitch)
                cameraNode!.eulerAngles.y = Float(currentAttitude.yaw)
                
                //move bike forward
                self.movePaperBoy(currentPitch: Float(currentAttitude.pitch)/30)
                
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

extension GameSceneRendererDelegate {
    func position(position:SCNVector3, multipliedByRotation rotation:SCNVector4) ->SCNVector3 {
        if rotation.w == 0 {
            return position
        }
        let gPosition = SCNVector3ToGLKVector3(position)
        let gRotation = GLKMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
        let r = GLKMatrix4MultiplyVector3(gRotation, gPosition)
        return SCNVector3FromGLKVector3(r);
    }
    
    func movePaperBoy(currentPitch:Float) {
        let step:Float = 0.2
        let x:Float = 0.0
        let y:Float = 0.0
        let z:Float = step
        
        var paperBoyPivot = self.paperBoyNode.pivot
        paperBoyPivot = SCNMatrix4Rotate(paperBoyPivot, currentPitch, 0.0, -1.0, 0.0);
        
        let rotatedPosition = self.position(position: SCNVector3Make(x,y,z), multipliedByRotation: paperBoyNode.rotation)
        paperBoyPivot = SCNMatrix4Translate(paperBoyPivot, rotatedPosition.x, rotatedPosition.y, rotatedPosition.z)
        print(self.paperBoyNode.transform)
        
        
        
        self.paperBoyNode.pivot = paperBoyPivot
    }
}
