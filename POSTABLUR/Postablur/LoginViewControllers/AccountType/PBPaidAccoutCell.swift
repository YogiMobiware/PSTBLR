//
//  PBPaidAccoutCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/19/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

protocol PBPaidAccoutCellDelegate {
    
    func pbnextBtnDidTap()
    
}

class PBPaidAccoutCell: UITableViewCell {

    var paidDelegate : PBPaidAccoutCellDelegate? = nil
    
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var getLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var donteLabel: UILabel!
    @IBOutlet weak var earnLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var getSponsoredabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        let fontSmallSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 18
        let roundedSmallfontSize = floor(fontSmallSize)
        
        let fontBoldSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 24
        let roundedBoldfontSize = floor(fontBoldSize)
        
        self.producerLabel.font = self.producerLabel.font.withSize(roundedBoldfontSize)
        self.costLabel.font = self.costLabel.font.withSize(roundedBoldfontSize)
        
        self.getLabel.font = self.getLabel.font.withSize(roundedSmallfontSize)
        self.viewLabel.font = self.viewLabel.font.withSize(roundedSmallfontSize)
        self.donteLabel.font = self.donteLabel.font.withSize(roundedSmallfontSize)
        self.earnLabel.font = self.earnLabel.font.withSize(roundedSmallfontSize)
        self.releaseLabel.font = self.releaseLabel.font.withSize(roundedSmallfontSize)
        self.getSponsoredabel.font = self.getSponsoredabel.font.withSize(roundedSmallfontSize)

        
    }

    @IBAction func nextBtnAction(_ sender: UIButton)
    {
        if let paidDelegate = self.paidDelegate
        {
            paidDelegate.pbnextBtnDidTap()
            
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
