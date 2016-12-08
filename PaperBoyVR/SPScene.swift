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
    var newspaper: SCNNode!
    var paperBoyNode: SCNNode!
    
    
    override init() {

        // camera
        cameraNode = sharedScene.childNode("cameraNode")
        newspaper = sharedScene.childNode("newspaper")
        paperBoyNode = sharedScene.childNode("paperBoyNode")
        
        sharedScene.background.contents = UIImage(named: "sky")
    }
    
}
