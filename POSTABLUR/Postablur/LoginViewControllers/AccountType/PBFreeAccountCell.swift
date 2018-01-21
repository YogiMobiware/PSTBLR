//
//  PBFreeAccountCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/19/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit


class PBFreeAccountCell: UITableViewCell {

    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var viewShareLabel: UILabel!
    @IBOutlet weak var donateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let fontSmallSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 18
        let roundedSmallfontSize = floor(fontSmallSize)
        
        let fontBoldSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 24
        let roundedBoldfontSize = floor(fontBoldSize)

        
        self.publicLabel.font = self.publicLabel.font.withSize(roundedBoldfontSize)
        self.freeLabel.font = self.freeLabel.font.withSize(roundedBoldfontSize)
        self.viewShareLabel.font = self.viewShareLabel.font.withSize(roundedSmallfontSize)
        self.donateLabel.font = self.donateLabel.font.withSize(roundedSmallfontSize)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
