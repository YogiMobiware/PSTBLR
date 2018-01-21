//
//  PBDollarLimitCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/20/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

protocol PBDollarLimitCellDelegate
{
    func oneDollarDidTap()
    func fiveDollarDidTap()
    func tenDollarDidTap()
    
}
class PBDollarLimitCell: UITableViewCell {

    @IBOutlet weak var oneDollarButton : UIButton!
    @IBOutlet weak var fiveDollarButton : UIButton!
    @IBOutlet weak var tenDollarButton : UIButton!
    var dollarLimitDelegate : PBDollarLimitCellDelegate? = nil
    @IBOutlet weak var dollarLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
      
        let labelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 16
        let roundedBoldfontSize = floor(labelfontSize)
        self.dollarLabel.font = self.dollarLabel.font.withSize(roundedBoldfontSize)
        
        let buttonfonSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedButtonfontSize = floor(buttonfonSize)
        self.oneDollarButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)
        self.fiveDollarButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)
        self.tenDollarButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func oneShareBtnAction(_ sender: UIButton)
    {
        if let dollarLimitDelegate = self.dollarLimitDelegate
        {
            dollarLimitDelegate.oneDollarDidTap()
        }
        
    }
    @IBAction func fiveLikeBtnAction(_ sender: UIButton)
    {
        if let dollarLimitDelegate = self.dollarLimitDelegate
        {
            dollarLimitDelegate.fiveDollarDidTap()
        }
    }
    @IBAction func tenLikeBtnAction(_ sender: UIButton)
    {
        if let dollarLimitDelegate = self.dollarLimitDelegate
        {
            dollarLimitDelegate.tenDollarDidTap()
        }
    }
    
}
