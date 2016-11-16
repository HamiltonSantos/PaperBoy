//
//  SPController.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 9/15/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import SceneKit

// Constants
let force = Float(5.5)
let defaultForceVector = SCNVector3Make(0, 1, -1)

class SPController: NSObject {
    weak var viewControllerDelegate: UIViewController?
    
    let music = SCNAudioSource(fileNamed: "art.scnassets/music.wav")
    let dangerMusic = SCNAudioSource(fileNamed: "art.scnassets/danger.wav")
    
    // Scene
    var sPScene = SPScene.sharedInstance
    
}

// newspaper
extension SPController {
    
    func throwNewspaper() {
        
        let nPPosition = self.sPScene.cameraNode.position
        self.sPScene.newspaper.position = nPPosition
        let vector = SCNVector3Make(-self.sPScene.cameraNode.eulerAngles.y, self.sPScene.cameraNode.eulerAngles.x + 0.2, -0.8) * 10// sPScene.cameraNode.eulerAngles
        self.throwNewspaper(vectorForce: vector)
        
    }
    
    func throwNewspaper(vectorForce: SCNVector3) {
        resetVelocity(node: sPScene.newspaper)
        applyForce(node: sPScene.newspaper, force: vectorForce)
        
    }
    
    func applyForce(node: SCNNode, force: SCNVector3) {
        
        node.physicsBody?.isAffectedByGravity = true
        node.physicsBody?.applyForce(force, asImpulse: true)
    }
}

// Sounds
extension SPController {
    
    func playMusic() {
        sPScene.cameraNode.runAction(.playAudio(music!, waitForCompletion: true)) {
            self.playMusic()
        }
    }
}

// Resets
extension SPController {
    func resetVelocity(node: SCNNode) {
        node.physicsBody?.velocity = SCNVector3Zero
        node.physicsBody?.angularVelocity = SCNVector4Zero
    }
}

//BLE CSC device
extension SPController {
    func readSpeed() {
        btDiscoverySharedInstance.peripherals.first?.readValue(for: speedCharacteristic!)
    }
}
