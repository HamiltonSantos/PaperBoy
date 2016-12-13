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
    var currentSpeed:Double = 0
    var crosshairDelegate:CrosshairDelegate?
    var currentCrosshairSize:CGFloat = 1.0
    
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
        if let view = aRenderer as? GameSceneView, view.isDelegate {
            if let mailbox = view.hitTest(view.hitTestPoint, options: nil).first?.node,
                mailbox.name == "Box001" {
                currentCrosshairSize -= 0.015
                print(currentCrosshairSize)
                if currentCrosshairSize < 0.2 {
                    self.currentCrosshairSize = 1.0
                    self.crosshairDelegate?.throwNewspaperAction()
                }
                self.crosshairDelegate?.resizeCrosshair(size: currentCrosshairSize)
            }
            
            SCNTransaction.commit()
        }
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
            //CHANGE
             self.paperBoyNode.transform = SCNMatrix4Rotate(self.paperBoyNode.transform, currentPitch, 0.0, 1.0, 0.0)
           /* let step:Float = Float(currentSpeed/300.0)
            let x:Float = 0.0
            let y:Float = 0.0
            let z:Float = step
            var paperBoyPivot = self.paperBoyNode.transform
            
            if abs(currentPitch) > 0.005 {
                paperBoyPivot = SCNMatrix4Rotate(paperBoyPivot, currentPitch, 0.0, -1.0, 0.0)
            }
            
            let rotatedPosition = self.position(position: SCNVector3Make(x,y,z), multipliedByRotation: paperBoyNode.rotation)
            paperBoyPivot = SCNMatrix4Translate(paperBoyPivot, rotatedPosition.x, rotatedPosition.y, rotatedPosition.z)
            
           // self.paperBoyNode.pivot = SCNMatrix4Translate(self.paperBoyNode.pivot, rotatedPosition.x, rotatedPosition.y, rotatedPosition.z)
            
            
            
            self.paperBoyNode.transform = paperBoyPivot*/
        }
    }
    
    protocol CrosshairDelegate: class {
        func resizeCrosshair(size:CGFloat)
        func throwNewspaperAction()
}
