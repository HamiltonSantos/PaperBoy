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
    
    @IBOutlet weak var sceneViewLeft: GameSceneView!
    @IBOutlet weak var sceneViewRight: GameSceneView!
    @IBOutlet weak var speedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SPScene.sharedInstance.sharedScene.isPaused = false
        
        gameController.viewControllerDelegate = self
        
        gameController.playMusic()
        
        DispatchQueue.global().async {
            
            self.throwNewspaper()
            
        }
    }
    
    func throwNewspaper() {
        self.gameController.throwNewsPaper()
        btDiscoverySharedInstance.peripherals.first?.readValue(for: speedCharacteristic!)
        sleep(3)
        self.throwNewspaper()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SPScene.sharedInstance.cameraNode.position.z = 0
        SPScene.sharedInstance.sharedScene.isPaused = true
    }
    
}
