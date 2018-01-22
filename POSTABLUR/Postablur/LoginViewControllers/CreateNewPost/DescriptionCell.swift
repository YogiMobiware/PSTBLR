//
//  DescriptionCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/22/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var charactersCntLabel : UILabel!
    @IBOutlet weak var descriptionTV : UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let descriptionLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedBoldfontSize = floor(descriptionLabelfontSize)
        self.descriptionLabel.font = self.descriptionLabel.font.withSize(roundedBoldfontSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
