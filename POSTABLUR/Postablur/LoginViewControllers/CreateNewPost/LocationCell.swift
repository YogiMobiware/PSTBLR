//
//  LocationCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/22/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell,UITextFieldDelegate
{
    //@IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var currentLocationLabel : UILabel!
    @IBOutlet weak var locationTF : UITextField!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        /*let locationLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 20
        let roundedBoldfontSize = floor(locationLabelfontSize)
        self.locationLabel.font = self.locationLabel.font.withSize(roundedBoldfontSize)*/
        //self.locationTF.delegate = self

    }

   
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
