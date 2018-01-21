//
//  PBSocialLoginCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/18/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
protocol PBSocialLoginCellDelegate
{
    
    func pbCreateBtnDidTap()
    func pbTwitterBtnDidTap()
    func pbfaceBookBtnDidTap()

}
class PBSocialLoginCell: UITableViewCell
{

    @IBOutlet weak var createButton : UIButton!
    @IBOutlet weak var facebookButton : UIButton!
    @IBOutlet weak var twitterButton : UIButton!
    var socialLoginDelegate : PBSocialLoginCellDelegate? = nil

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func createButtonAction(_ sender: UIButton)
    {
        if let socialLoginDelegate = self.socialLoginDelegate
        {
            socialLoginDelegate.pbCreateBtnDidTap()
        }
    }
    @IBAction func twitterButtonAction(_ sender: UIButton)
    {
        if let socialLoginDelegate = self.socialLoginDelegate
        {
            socialLoginDelegate.pbTwitterBtnDidTap()

        }
    }
    @IBAction func faceBookButtonAction(_ sender: UIButton)
    {
        if let socialLoginDelegate = self.socialLoginDelegate
        {
            socialLoginDelegate.pbfaceBookBtnDidTap()

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
