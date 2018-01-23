//
//  ShareYourPost.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/22/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

protocol ShareYourPostDelegate
{
    
    func pbPublicOrPrivateDidTap(privateOrPublicButton:UIButton)
    func pbTwitterBtnDidTap()
    func pbFaceBookBtnDidTap()
    func pbDonateBtnDidTap(selectedDonatedButton : UIButton)

    
}
class ShareYourPost: UITableViewCell {

    @IBOutlet weak var shareTitleLabel : UILabel!
    @IBOutlet weak var donateCharityLabel : UILabel!
    @IBOutlet weak var whoGetsTitleLabel : UILabel!

    var shareYourPostDelegate : ShareYourPostDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        let shareLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedBoldfontSize = floor(shareLabelfontSize)
        self.shareTitleLabel.font = self.shareTitleLabel.font.withSize(roundedBoldfontSize)
        self.donateCharityLabel.font = self.donateCharityLabel.font.withSize(roundedBoldfontSize)
        self.whoGetsTitleLabel.font = self.whoGetsTitleLabel.font.withSize(roundedBoldfontSize)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func twitterBtnAction(_ sender: UIButton)
    {
        sender.backgroundColor = .clear
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = Constants.navBarTintColor.cgColor

        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbTwitterBtnDidTap()
        }
    }
    @IBAction func faceBookBtnAction(_ sender: UIButton)
    {
        sender.backgroundColor = .clear
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = Constants.navBarTintColor.cgColor
        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbFaceBookBtnDidTap()
        }
        
    }
    @IBAction func donateBtnAction(_ sender: UIButton)
    {
        sender.backgroundColor = .clear
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = Constants.navBarTintColor.cgColor

        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbDonateBtnDidTap(selectedDonatedButton: sender)
        }
        
    }
    @IBAction func whoGetsRevealBtnAction(_ sender: UIButton)
    {
        sender.backgroundColor = .clear
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = Constants.navBarTintColor.cgColor

        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbPublicOrPrivateDidTap(privateOrPublicButton: sender)
        }
    }
    
}
