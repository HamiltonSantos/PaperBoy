//
//  SPScene.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 8/21/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import SceneKit

class SPScene : NSObject {
    
    static let sharedInstance = SPScene()
    
    let sharedScene = SCNScene(named: "art.scnassets/SPScene.scn")!
    
    
    var cameraNode: SCNNode!
    var rightCameraNode: SCNNode!
    var newspaper: SCNNode!
    var paperBoyNode: SCNNode!
    
    
    override init() {

        // camera
        cameraNode = sharedScene.childNode("cameraNode")
        //CHANGE
        rightCameraNode = sharedScene.childNode("rightCamera")
        newspaper = sharedScene.childNode("newspaper")
        paperBoyNode = sharedScene.childNode("paperBoyNode")
        
        sharedScene.background.contents = UIImage(named: "sky")
        
        //CHANGE
        self.paperBoyNode.pivot = SCNMatrix4MakeTranslation(-1.4, 0, 24)
    }
    
}
