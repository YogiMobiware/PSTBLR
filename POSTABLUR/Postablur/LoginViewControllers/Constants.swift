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

enum UploadedImageType : String{
    
    case CapturedPhotoFromCamera = "CapturedPhotoFromCamera"
    case UploadedPhotoFromLibrary = "UploadedPhotoFromLibrary"
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
    case TitleCellIdentifier = "TitleCellID"
    case LocationCellIdentifier = "LocationCellID"
    case ShareYourPostCellIdentifier = "ShareYourPostCellID"
    case DescriptionCellIdentifier = "DescriptionCellID"
    case AccountsSettingsCellIdentifier = "AccountsSettingsCellID"

}

enum FontName : String {
    
    case AvenirBlack = "Avenir-Black"
}

class Constants: NSObject {

    static let kUserProfilePicURL = "Profileurl"

    static let placedHolderTextFieldColor : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

    static let animationDuration: TimeInterval = 0.15
    
    static let maxBlurRadius : Int = 50
    
    static let feedPageSize  = 50
    static let loadMoreFeedPageSize : Int = 50
    
    static func textFieldPalceHolderColor(placeHolderText : String) ->NSAttributedString
    {
        return NSAttributedString(string:placeHolderText, attributes: [NSAttributedStringKey.foregroundColor: Constants.placedHolderTextFieldColor])
    }
    
    
    // MARK: Colors
    static let navBarTintColor : UIColor = UIColor(red: 0/255, green: 175/255, blue: 0/255, alpha: 1)
    static let headerTileColor : UIColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)

    static let greyTintColor : UIColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
    static let whiteTextColor : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

    
    static func getDoneToolbar(dismissBtn: UIBarButtonItem) -> UIToolbar
    {
        let doneToolbar = UIToolbar()
        
        doneToolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = dismissBtn
        doneToolbar.setItems([spaceButton, doneButton], animated: false)
        doneToolbar.isUserInteractionEnabled = true
        
        return doneToolbar
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
