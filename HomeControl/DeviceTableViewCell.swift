//
//  DeviceTableViewCell.swift
//  HomeControl
//
//  Created by Yurii Krupa on 12/12/18.
//  Copyright © 2018 Yurii Krupa. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var DeviceNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
