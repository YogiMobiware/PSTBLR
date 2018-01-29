//
//  FollowUsCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/29/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class FollowUsCell: UITableViewCell {

    @IBOutlet weak var followOnTwitter : UIButton!
    @IBOutlet weak var followOnSnapChat : UIButton!
    @IBOutlet weak var followOnInstagram : UIButton!
    @IBOutlet weak var followOnFacebook : UIButton!
    @IBOutlet weak var followOnYoutube : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }
    @IBAction func followUsOnSocialBtnAction(_ sender: UIButton)
    {
        
    }
   

    
}
