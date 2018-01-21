//
//  PBEmailAndPasswrdCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/18/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

protocol PBEmailAndPasswrdCellDelegate
{
    
    func pbLoginBtnDidTap(emailTextField: UITextField, passwordTextField : UITextField)
    func pbForgetPasswordDidTap()

}


class PBEmailAndPasswrdCell: UITableViewCell
{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var forgetPasswordButton : UIButton!
    var emailDelegate : PBEmailAndPasswrdCellDelegate? = nil
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        emailTextField.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Email.rawValue)
        
        passwordTextField.attributedPlaceholder = Constants.textFieldPalceHolderColor(placeHolderText: PlaceHolderText.Password.rawValue)
       
    }

    @IBAction func loginBtnAction(_ sender: UIButton)
    {
        if let emailDelegate = self.emailDelegate
        {
            emailDelegate.pbLoginBtnDidTap(emailTextField: emailTextField, passwordTextField: passwordTextField)
       
        }
    }
    @IBAction func forgetPasswordButtonAction(_ sender: UIButton)
    {
        if self.emailDelegate != nil
        {
            self.emailDelegate?.pbForgetPasswordDidTap()
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
