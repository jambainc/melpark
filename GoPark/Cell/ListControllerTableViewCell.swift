//
//  ListControllerTableViewCell.swift
//  GoPark
//
//  Created by Michael Wong on 29/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class ListControllerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viwCard: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viwOccRate: UIView!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblSign: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTravelTime: UILabel!
    @IBOutlet weak var lblNextAvailable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
