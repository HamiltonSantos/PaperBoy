//
//  GameSceneView.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 9/1/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import SceneKit

class GameSceneView: SCNView {
    
    @IBInspectable var cameraName: String = "centerCamera"
    @IBInspectable var isDelegate : Bool = false
    
    override func awakeFromNib() {
        // create a new scene
        super.awakeFromNib()
        preferredFramesPerSecond = 30
        self.scene = SPScene.sharedInstance.sharedScene
        
        // retrieve the SCNView
        self.pointOfView = scene!.rootNode.childNode(withName: cameraName, recursively: true)
        
        if isDelegate {
            self.isPlaying = true
            self.antialiasingMode = .multisampling4X
            #if os(tvOS)
                //self.delegate = TVPongSceneRendererDelegate.sharedInstance
            #else
                self.delegate = GameSceneRendererDelegate.sharedInstance
            #endif
        }else {
            self.delegate = nil
        }
        
    }
    
    
}
