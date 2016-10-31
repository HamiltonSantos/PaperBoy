//
//  GameViewController.swift
//  PaperBoyMultiplayer
//
//  Created by Hamilton Carlos da Silva Santos on 9/21/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    let gameControllerManager = GameControllerManager()

    override func viewDidLoad() {
        super.viewDidLoad()

}

extension GameViewController : GameControllerManagerDelegate {
    
    func didReceiveData(fromPlayer player: Int, data: NSData){
        
    }
    
    func didReceiveSpeed(fromPlayer player: Int, speed: Float){
        switch command {
        case .Left:
            pongController.applyOtherBallForce()
            break
        case .Right:
            pongController.applyOtherBallForce()
            break
        default: break
        }
    }
    
    func playerDidConnect(player: Int){
        
    }
    
    func playerDidDisconnect(player: Int){
        
    }
}
