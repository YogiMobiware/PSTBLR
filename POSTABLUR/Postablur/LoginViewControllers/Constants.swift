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

enum UploadedImageType : String
{
    
    case CapturedPhotoFromCamera = "CapturedPhotoFromCamera"
    case UploadedPhotoFromLibrary = "UploadedPhotoFromLibrary"
}
enum CellIdentifiers: String
{
    
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
    case BlurImageCellIdentifier = "BlurImageCellID"

}

enum FontName : String
{
    
    case AvenirBlack = "Avenir-Black"
}

class Constants: NSObject
{
    
    static let termsAndConditionsURL = "https://www.1millioncups.com/privacy-terms"
    static let privacyURL = "https://www.1millioncups.com/privacy-terms"
    static let termsText = "OVERVIEW This website is operated by KAVALEO, Inc.. Throughout the site, the terms “we”, “us” and “our” refer to KAVALEO, Inc.. KAVALEO, Inc. offers this website, including all information, tools and services available from this site to you, the user, conditioned upon your acceptance of all terms, conditions, policies and notices stated here. By visiting our site and/ or purchasing something from us, you engage in our “Service” and agree to be bound by the following terms and conditions (“Terms of Service”, “Terms”), including those additional terms and conditions and policies referenced herein and/or available by hyperlink. These Terms of Service apply to all users of the site, including without limitation users who are browsers, vendors, customers, merchants, and/ or contributors of content. Please read these Terms of Service carefully before accessing or using our website. By accessing or using any part of the site, you agree to be bound by these Terms of Service. If you do not agree to all the terms and conditions of this agreement, then you may not access the website or use any services. If these Terms of Service are considered an offer, acceptance is expressly limited to these Terms of Service. Any new features or tools which are added to the current store shall also be subject to the Terms of Service."
    
    static let privacyText = "KAVALEO, Inc. operates the www.postablur.com website, and app which provides the SERVICE.This page is used to inform website visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.If you choose to use our Service, then you agree to the collection and use of information in relation with this policy. The Personal Information that we collect are used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at www.postablur.com , unless otherwise defined in this Privacy Policy.Information Collection and Use For a better experience while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to your name, phone number, and postal address. The information that we collect will be used to contact or identify you.Log Data We want to inform you that whenever you visit our Service, we collect information that your browser sends to us that is called Log Data. This Log Data may include information such as your computer’s Internet Protocol (“IP”) address, browser version, pages of our Service that you visit, the time and date of your visit, the time spent on those pages, and other statistics."
    
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

    static let cell_HighlightedColor : UIColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)
    
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
