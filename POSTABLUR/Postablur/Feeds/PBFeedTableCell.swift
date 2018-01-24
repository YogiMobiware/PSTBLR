//
//  PBFeedTableCell.swift
//  Postablur
//
//  Created by Yogi on 23/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation

enum PBFeedAction
{
    case like
    case dislike
    case share
    case donate
}

protocol PBFeedTableCellDelegate
{
    func pbFeedTableCell(cell : PBFeedTableCell, didSelectAction action : PBFeedAction)
}

class PBFeedTableCell : UITableViewCell
{
    @IBOutlet var feedImageView : UIImageView!
    @IBOutlet var postUserPicImageView : UIImageView!
    @IBOutlet var postTitleLbl : UILabel!
    @IBOutlet var postDescriptionLbl : UILabel!
    @IBOutlet var postLocationLbl : UILabel!
    @IBOutlet var postViewsCountLbl : UILabel!
    @IBOutlet var postTimeElapsedLbl : UILabel!
    @IBOutlet var postUsernameLbl : UILabel!
    @IBOutlet var postLikesCountLbl : UILabel!
    @IBOutlet var postDislikesCountLbl : UILabel!
    @IBOutlet var postSharesCountLbl : UILabel!
    @IBOutlet var postDonorsCountLbl : UILabel!

    @IBOutlet var postLikeBtn : UIButton!
    @IBOutlet var postDislikeBtn : UIButton!
    @IBOutlet var postShareBtn : UIButton!
    @IBOutlet var postDonateBtn : UIButton!

    
    var delegate : PBFeedTableCellDelegate? = nil
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        if let image = postLikeBtn.imageView?.image
        {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            postLikeBtn.setImage(templateImage, for: .selected)
            postLikeBtn.setImage(templateImage, for: .normal)

        }
        
        if let image = postDislikeBtn.imageView?.image
        {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            postDislikeBtn.setImage(templateImage, for: .selected)
            postDislikeBtn.setImage(templateImage, for: .normal)

        }
        
        if let image = postShareBtn.imageView?.image
        {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            postShareBtn.setImage(templateImage, for: .selected)
            postShareBtn.setImage(templateImage, for: .normal)

        }
        
        if let image = postDonateBtn.imageView?.image
        {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            postDonateBtn.setImage(templateImage, for: .selected)
            postDonateBtn.setImage(templateImage, for: .normal)

        }

    }
    
    @IBAction func likeTapped(_ sender : UIButton)
    {
        guard let dlgate = self.delegate else
        {
            return
        }
        dlgate.pbFeedTableCell(cell: self, didSelectAction: .like)
    }
    
    @IBAction func dislikeTapped(_ sender : UIButton)
    {
        guard let dlgate = self.delegate else
        {
            return
        }
        dlgate.pbFeedTableCell(cell: self, didSelectAction: .dislike)
    }
    
    @IBAction func shareTapped(_ sender : UIButton)
    {
        guard let dlgate = self.delegate else
        {
            return
        }
        dlgate.pbFeedTableCell(cell: self, didSelectAction: .share)
    }
    
    @IBAction func donateTapped(_ sender : UIButton)
    {
        guard let dlgate = self.delegate else
        {
            return
        }
        dlgate.pbFeedTableCell(cell: self, didSelectAction: .donate)
    }
}
