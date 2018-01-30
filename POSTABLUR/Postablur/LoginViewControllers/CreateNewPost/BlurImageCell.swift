//
//  BlurImageCell.swift
//  Postablur
//
//  Created by Saraschandra on 30/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class BlurImageCell: UITableViewCell
{
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet var likesToReveal: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("1.jpg"))
        let blurredImage    = UIImage(contentsOfFile: imgPath.path)
        selectedImageView.image =  PBUtility.blurEffect(image: blurredImage!)

    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
