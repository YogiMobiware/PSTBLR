//
//  PBShareLimitCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/20/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
protocol PBShareLimitCellDelegate
{
    func oneShareDidTap()
    func fiveShareDidTap()
    func tenShareDidTap()
    
}
class PBShareLimitCell: UITableViewCell {

    @IBOutlet weak var oneShareButton : UIButton!
    @IBOutlet weak var fiveShareButton : UIButton!
    @IBOutlet weak var tenShareButton : UIButton!
    var shareLimitDelegate : PBShareLimitCellDelegate? = nil
    @IBOutlet weak var shareLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        let labelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 16
        let roundedBoldfontSize = floor(labelfontSize)
        self.shareLabel.font = self.shareLabel.font.withSize(roundedBoldfontSize)
        
        let buttonfonSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedButtonfontSize = floor(buttonfonSize)
        self.oneShareButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)
        self.fiveShareButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)
        self.tenShareButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func oneShareBtnAction(_ sender: UIButton)
    {
        if let shareLimitDelegate = self.shareLimitDelegate
        {
            shareLimitDelegate.oneShareDidTap()
        }
        
    }
    @IBAction func fiveLikeBtnAction(_ sender: UIButton)
    {
        if let shareLimitDelegate = self.shareLimitDelegate
        {
            shareLimitDelegate.fiveShareDidTap()
        }
    }
    @IBAction func tenLikeBtnAction(_ sender: UIButton)
    {
        if let shareLimitDelegate = self.shareLimitDelegate
        {
            shareLimitDelegate.tenShareDidTap()
        }
    }
    
}
