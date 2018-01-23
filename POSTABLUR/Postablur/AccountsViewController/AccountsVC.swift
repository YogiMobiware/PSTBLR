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
    @IBOutlet var accountsFeedsCollectionView: UICollectionView!
    
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    private let reuseIdentifier = "accountsCollectionCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        accountsFeedsCollectionView.delegate = self
        accountsFeedsCollectionView.dataSource = self
        let nib = UINib(nibName: NibNamed.AccountsCollectionCell.rawValue, bundle: nil)
        self.accountsFeedsCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let username = ""
        var _ = "@ \(username)"
        
        self.fontSet()
        
        //self.loadMyPostsDetails()
    
    }
    
    func loadMyPostsDetails()
    {
        let urlString = String(format: "%@/MyPostsDetails", arguments: [Urls.mainUrl]);
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else
        {
            return
        }
        let requestDict = ["UserId": userId,"StartValue": "1","Endvalue": "20"] as [String : Any]
        
        self.activity.startAnimating()
        self.activity.isHidden = false
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            self.activity.stopAnimating()
            
            if error == nil
            {
                if responseObject != nil
                {
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        if let error = responseDict["Error"] as? String
                        {
                            self.appDelegate.alert(vc: self, message: error , title: "Error")
                            return
                        }
                        else
                        {
                            return
                        }
                        
                    }
                    if let responseStr = responseObject as? String
                    {
                        self.appDelegate.alert(vc: self, message: responseStr, title: "Error")
                        return
                    }
                    
                }
                else
                {
                    self.appDelegate.alert(vc: self, message: "Something went wrong", title: "Error")
                    return
                }
            }
            else
            {
                self.appDelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Error")
                return
            }
        }
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

extension AccountsVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AccountsCollectionCell
       
        
        return cell
        
    }
}