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
    
    
    // Camera Node
    var cameraNode: SCNNode!
    
    // Newspaper
    var newspaper: SCNNode!
    
    // Bike
    var bike: SCNNode!
    
    
    override init() {

        // camera
        cameraNode = sharedScene.childNode("cameraNode")
        newspaper = sharedScene.childNode("newspaper")
        bike = sharedScene.childNode("bike")
        
        // Initial Positions
//        self.mySideInitialLeftPosition = sharedScene.childNode("mySideStartPointLeft").position
//        self.mySideInitialRightPosition = sharedScene.childNode("mySideStartPointRight").position
//        self.mySideInitialCenterPosition = sharedScene.childNode("mySideStartPointCenter").position
//        
//        self.otherSideInitialLeftPosition = sharedScene.childNode("otherSideStartPointLeft").position
//        self.otherSideInitialRightPosition = sharedScene.childNode("otherSideStartPointRight").position
//        self.otherSideInitialCenterPosition = sharedScene.childNode("otherSideStartPointCenter").position
        sharedScene.background.contents = UIImage(named: "sky")
    }
    
}
