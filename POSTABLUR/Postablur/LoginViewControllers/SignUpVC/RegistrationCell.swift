//
//  RegistrationCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/18/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

protocol RegistrationCellDelegate
{
    
    func pbnextBtnDidTap(userNameTF : UITextField, emailTF : UITextField, passwordTF : UITextField, reTypePasswordTF : UITextField)
    
    func pbloginBtnDidTap()
    
    //func moveToPBWebVC(toController : UIViewController)
}
class RegistrationCell: UITableViewCell,UITextViewDelegate
{

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var reTypePasswordTF: UITextField!
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet var termsTextView: UITextView!
    @IBOutlet weak var nextBtn : UIButton!
    var registerDelegate : RegistrationCellDelegate? = nil

    override func awakeFromNib()
    {
        super.awakeFromNib()
      
        emailTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Email.rawValue)
        
        userNameTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Username.rawValue)
        
        passwordTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Password.rawValue)
        
        reTypePasswordTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.RetypePassword.rawValue)
        
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let str = "signing up you agree to our Terms of Use and Privacy Policy."
        
        var attributedString = NSMutableAttributedString(string: str)
        
        attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir-Roman", size: 8)!])
        
        attributedString = NSMutableAttributedString(string: str,attributes: [NSAttributedStringKey.paragraphStyle: paragraph])
        
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: str.count))
        
        let termsRange = attributedString.mutableString.range(of: "Terms of Use")
        attributedString.addAttribute(NSAttributedStringKey.link, value: Constants.termsAndConditionsURL, range: termsRange)
        
        let privacyRange = attributedString.mutableString.range(of: "Privacy Policy.")
        attributedString.addAttribute(NSAttributedStringKey.link, value: Constants.privacyURL, range: privacyRange)
        
        termsTextView.attributedText = attributedString
        termsTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue :Constants.cell_HighlightedColor]
        termsTextView.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    
    @IBAction func nextBtnAction(_ sender: UIButton)
    {
        if let registerDelegate = self.registerDelegate
        {
            registerDelegate.pbnextBtnDidTap(userNameTF: userNameTF, emailTF: emailTF, passwordTF: passwordTF, reTypePasswordTF: reTypePasswordTF)
        
        }
        
    }

    @IBAction func loginBtnAction(_ sender: UIButton)
    {
        if let registerDelegate = self.registerDelegate
        {
            registerDelegate.pbloginBtnDidTap()
        }
        
    }

    
}
