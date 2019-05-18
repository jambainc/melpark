//
//  SettingControllerTableViewCell.swift
//  GoPark
//
//  Created by Michael Wong on 20/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class SettingControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCellIcon: UIImageView!
    @IBOutlet weak var lblCellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
