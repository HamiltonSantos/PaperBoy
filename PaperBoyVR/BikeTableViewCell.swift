//
//  bikeTableViewCell.swift
//  PaperBoyVR
//
//  Created by Hamilton Carlos da Silva Santos on 10/16/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class BikeTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
