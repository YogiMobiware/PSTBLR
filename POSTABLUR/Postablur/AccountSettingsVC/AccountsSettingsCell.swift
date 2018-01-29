//
//  AccountsSettingsCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/23/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class AccountsSettingsCell: UITableViewCell {

    @IBOutlet weak var accountsLabel : UILabel!
    @IBOutlet weak var arrowImage : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let labelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 18
        let roundedBoldfontSize = floor(labelfontSize)
        self.accountsLabel.font = self.accountsLabel.font.withSize(roundedBoldfontSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
