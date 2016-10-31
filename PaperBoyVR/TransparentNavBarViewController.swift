//
//  TransparentNavBarViewController.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 9/13/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import UIKit

class TransparentNavBarViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
}
