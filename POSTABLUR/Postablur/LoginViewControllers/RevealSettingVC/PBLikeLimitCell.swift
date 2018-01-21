//
//  PBLikeLimitCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/20/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
protocol PBLikeLimitCellDelegate
{
    func oneLikeDidTap()
    func fiveLikeDidTap()
    func tenLikeDidTap()

}

class PBLikeLimitCell: UITableViewCell {
   
    @IBOutlet weak var oneLikeButton : UIButton!
    @IBOutlet weak var fiveLikeButton : UIButton!
    @IBOutlet weak var tenLikeButton : UIButton!
    @IBOutlet weak var likeLabel : UILabel!

    var likeLimitDelegate : PBLikeLimitCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
       
        let labelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 16
        let roundedBoldfontSize = floor(labelfontSize)
        self.likeLabel.font = self.likeLabel.font.withSize(roundedBoldfontSize)

        let buttonfonSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedButtonfontSize = floor(buttonfonSize)
        self.oneLikeButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)
        self.fiveLikeButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)
        self.tenLikeButton.titleLabel?.font = UIFont(name: FontName.AvenirBlack.rawValue, size: roundedButtonfontSize)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func oneLikeBtnAction(_ sender: UIButton)
    {
        if let likeLimitDelegate = self.likeLimitDelegate
        {
            likeLimitDelegate.oneLikeDidTap()
        }
    
    }
    @IBAction func fiveLikeBtnAction(_ sender: UIButton)
    {
        if let likeLimitDelegate = self.likeLimitDelegate
        {
            likeLimitDelegate.fiveLikeDidTap()
        }
    }
    @IBAction func tenLikeBtnAction(_ sender: UIButton)
    {
        if let likeLimitDelegate = self.likeLimitDelegate
        {
            likeLimitDelegate.tenLikeDidTap()
        }
    }
    
}
