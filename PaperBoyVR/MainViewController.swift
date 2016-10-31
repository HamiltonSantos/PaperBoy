//
//  MainViewController.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 30/10/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class MainViewController: TransparentNavBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterMultiplayerTouchUpInside(_ sender: Any) {
        let nameAlert = UIAlertController(title: "What's your nickname?", message: "enter your multiplayer nickname", preferredStyle: UIAlertControllerStyle.alert)
        
        nameAlert.addTextField { (textField) in
            textField.placeholder = "example123"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            let nameTextField = nameAlert.textFields?.first
            if nameTextField?.text != "" {
                User.sharedInstance.name = nameTextField?.text
                self.performSegue(withIdentifier: "multiplayerSegue", sender: self)
            }
        })
        
        nameAlert.addAction(okAction)
        
        self.present(nameAlert, animated: true, completion: nil)

    }
    

}
