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
class ShareYourPost: UITableViewCell
{

    @IBOutlet weak var shareTitleLabel : UILabel!
    @IBOutlet weak var donateCharityLabel : UILabel!
    @IBOutlet weak var whoGetsTitleLabel : UILabel!
    @IBOutlet weak var twitterBtn : UIButton!
    @IBOutlet weak var facebookBtn : UIButton!
    @IBOutlet weak var publicAccessBtn : UIButton!
    @IBOutlet weak var privateAccessBtn : UIButton!
    @IBOutlet weak var unitedWayBtn : UIButton!
    @IBOutlet weak var americanCancerBtn : UIButton!
    @IBOutlet weak var americanRedCrossBtn : UIButton!
    @IBOutlet weak var americanHeartAssocBtn : UIButton!
    @IBOutlet weak var boysAndGirlsBtn : UIButton!

    var shareYourPostDelegate : ShareYourPostDelegate? = nil

    override func awakeFromNib()
    {
        super.awakeFromNib()
        let shareLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedBoldfontSize = floor(shareLabelfontSize)
        self.shareTitleLabel.font = self.shareTitleLabel.font.withSize(roundedBoldfontSize)
        self.donateCharityLabel.font = self.donateCharityLabel.font.withSize(roundedBoldfontSize)
        self.whoGetsTitleLabel.font = self.whoGetsTitleLabel.font.withSize(roundedBoldfontSize)

    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func twitterBtnAction(_ sender: UIButton)
    {
        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbTwitterBtnDidTap()

            if sender.isSelected == false
            {
                if let image = twitterBtn.imageView?.image
                {
                    let templateImage = image.withRenderingMode(.alwaysTemplate)
                    twitterBtn.setImage(templateImage, for: .selected)
                }
                sender.isSelected = true
            }
            else
            {
                sender.isSelected = false

            }
        }
        
    }
    @IBAction func faceBookBtnAction(_ sender: UIButton)
    {
        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbFaceBookBtnDidTap()
            
           /* if sender.isSelected == false
            {
                if let image = facebookBtn.imageView?.image
                {
                    let templateImage = image.withRenderingMode(.alwaysTemplate)
                    facebookBtn.setImage(templateImage, for: .selected)
                }
                sender.isSelected = true
            }
            else
            {
                sender.isSelected = false
                
            }*/
        }
        
    }
    @IBAction func donateBtnAction(_ sender: UIButton)
    {

        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbDonateBtnDidTap(selectedDonatedButton: sender)
        }
        
    }
    @IBAction func whoGetsRevealBtnAction(_ sender: UIButton)
    {

        if let shareYourPostDelegate = self.shareYourPostDelegate
        {
            shareYourPostDelegate.pbPublicOrPrivateDidTap(privateOrPublicButton: sender)
        }
    }
   
}
