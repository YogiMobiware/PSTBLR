//
//  TitleCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/22/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var charactersCountLabel : UILabel!
    @IBOutlet weak var titleTF : UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    
        let titleLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedBoldfontSize = floor(titleLabelfontSize)
        self.titleLabel.font = self.titleLabel.font.withSize(roundedBoldfontSize)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
