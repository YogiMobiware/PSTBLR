//
//  AccountsVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/23/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class AccountsVC: UIViewController
{
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var settingsBtn: UIButton!
    
    
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var connectBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userDescLabel: UILabel!
    @IBOutlet var connectsView: UIView!
    @IBOutlet var connectsLabel: UILabel!
    @IBOutlet var sponcersView: UIView!
    @IBOutlet var sponcersLabel: UILabel!
    @IBOutlet var donorsView: UIView!
    @IBOutlet var donorsLabel: UILabel!
    
    @IBOutlet var videoView: UIView!
    
    @IBOutlet var buttonsView: UIView!
    
    @IBOutlet var dataView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        let username = ""
        var _ = "@ \(username)"
        
        self.fontSet()
    
    }
    
    func fontSet()
    {
        let allLabelsfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 12
        let fontSize = floor(allLabelsfontSize)
        self.connectBtn.titleLabel?.font = self.connectBtn.titleLabel?.font.withSize(fontSize)
        self.usernameLabel.font = self.usernameLabel.font.withSize(fontSize)
        self.userDescLabel.font = self.userDescLabel.font.withSize(fontSize)
        self.connectsLabel.font = self.connectsLabel.font.withSize(fontSize)
        self.sponcersLabel.font = self.sponcersLabel.font.withSize(fontSize)
        self.donorsLabel.font = self.donorsLabel.font.withSize(fontSize)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func settingsBtnAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func connectBtnAction(_ sender: UIButton)
    {
        
    }
}
