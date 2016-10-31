//
//  User.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 30/10/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name:String?
    var currentSpeed:Double = 0
    
    static let sharedInstance: User = {
        let instance = User()
        
        // setup code
        
        return instance
    }()
    

}
