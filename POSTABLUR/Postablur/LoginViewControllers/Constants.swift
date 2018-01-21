//
//  Constants.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/17/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

enum PlaceHolderText: String
{
    case Email = "EMAIL"
    case Username = "USERNAME"
    case RetypePassword = "RE-TYPE PASSWORD"
    case Password = "PASSWORD"
    case UsernameEmail = "USERNAME/EMAIL"

}

enum CellIdentifiers: String{
    
    case LogoHeaderReuseIdentifier = "PBLogoCellID"
    case EmailAndPasswrdReuseIdentifier = "PBEmailAndPasswrdCellID"
    case SocialReuseIdentifier = "PBSocialLoginCellID"
    case AddProfilePhotoCellIdentifier = "AddProfilePhotoCellID"
    case RegistrationCellIdentifier = "RegistrationCellID"
    case PBHeaderCellIdentifier = "PBHeaderCellID"
    case PBFreeAccountCellIdentifier = "PBFreeAccountCellID"
    case PBPaidAccoutCellIdentifier = "PBPaidAccoutCellID"
    case PBLikeLimitCellIdentifier = "PBLikeLimitCellID"
    case PBShareLimitCellIdentifier = "PBShareLimitCellID"
    case PBDollarLimitCellIdentifier = "PBDollarLimitCellID"

}

enum FontName : String {
    
    case AvenirBlack = "Avenir-Black"
}

class Constants: NSObject {

    static let placedHolderTextFieldColor : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

    static let animationDuration: TimeInterval = 0.15
    
    static func textFieldPalceHolderColor(placeHolderText : String) ->NSAttributedString
    {
        return NSAttributedString(string:placeHolderText, attributes: [NSAttributedStringKey.foregroundColor: Constants.placedHolderTextFieldColor])
    }
    
   static func calculateDynamicTableviewCellHeight(cellHeight : CGFloat) -> CGFloat
    {
        let cellDefaultHeight : CGFloat = cellHeight
        let screenDefaultHeight : CGFloat = UIScreen.main.bounds.size.height
        let factor : CGFloat = cellDefaultHeight/screenDefaultHeight
        print(factor)
        return factor * UIScreen.main.bounds.size.height
    }
}
