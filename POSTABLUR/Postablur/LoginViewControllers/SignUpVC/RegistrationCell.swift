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
    
}
class RegistrationCell: UITableViewCell
{

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var reTypePasswordTF: UITextField!
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet weak var nextBtn : UIButton!
    var registerDelegate : RegistrationCellDelegate? = nil

    override func awakeFromNib()
    {
        super.awakeFromNib()
      
        emailTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Email.rawValue)
        
        userNameTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Username.rawValue)
        
        passwordTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Password.rawValue)
        
        reTypePasswordTF.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.RetypePassword.rawValue)
        
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
