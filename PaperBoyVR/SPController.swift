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
        ///////////////////////////////////////////////////////////
//        //get hero direction vector
//        let angle = heroNode.presentationNode.rotation.w * heroNode.presentationNode.rotation.y
//        var direction = SCNVector3(x: -sin(angle), y: 0, z: -cos(angle))
//        
//        //get elevation
//        direction = SCNVector3(x: cos(elevation) * direction.x, y: sin(elevation), z: cos(elevation) * direction.z)
//        
//        //create or recycle bullet node
//        let bulletNode: SCNNode = {
//            if self.bullets.count < self.maxBullets {
//                return SCNNode()
//            } else {
//                return self.bullets.removeAtIndex(0)
//            }
//        }()
//        bullets.append(bulletNode)
//        bulletNode.geometry = SCNBox(width: CGFloat(bulletRadius) * 2, height: CGFloat(bulletRadius) * 2, length: CGFloat(bulletRadius) * 2, chamferRadius: CGFloat(bulletRadius))
//        bulletNode.position = SCNVector3(x: heroNode.presentationNode.position.x, y: 0.4, z: heroNode.presentationNode.position.z)
//        bulletNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: SCNPhysicsShape(geometry: bulletNode.geometry!, options: nil))
//        bulletNode.physicsBody?.categoryBitMask = CollisionCategory.Bullet
//        bulletNode.physicsBody?.collisionBitMask = CollisionCategory.All ^ CollisionCategory.Hero
//        bulletNode.physicsBody?.velocityFactor = SCNVector3(x: 1, y: 0.5, z: 1)
//        self.sceneView.scene!.rootNode.addChildNode(bulletNode)
        ///////////////////////////////////////////////////////////
        let bikeRotation = self.sPScene.paperBoyNode.presentation.rotation
        let cameraRotation = self.sPScene.cameraNode.presentation.rotation
        var direction = SCNVector4Make(bikeRotation.x * cameraRotation.x, bikeRotation.y * cameraRotation.y, bikeRotation.z * cameraRotation.z, bikeRotation.w * cameraRotation.w)
        
        
        
        self.sPScene.newspaper.position = SCNVector3Make(self.sPScene.paperBoyNode.position.x, self.sPScene.paperBoyNode.position.y + 4, self.sPScene.paperBoyNode.position.z)
        self.throwNewspaper(vectorForce: direction) bubugubugubug
        
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
