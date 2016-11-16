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
        
        self.readSpeed()
        
        self.throwNewspaper()
        
    }
    
    func throwNewspaper() {
        DispatchQueue.global().async {
            self.gameController.throwNewspaper()
            sleep(3)
            self.throwNewspaper()
        }
    }
    
    func readSpeed() {
        DispatchQueue.global().async {
            self.gameController.readSpeed()
            sleep(10)
            self.readSpeed()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SPScene.sharedInstance.cameraNode.position.z = 0
        SPScene.sharedInstance.sharedScene.isPaused = true
    }
    
}
