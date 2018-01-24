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
    @IBOutlet var settingsBtn: UIButton!
    
    
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var connectBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userDescTextView: UITextView!
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
    @IBOutlet var postsNotAvailLabel: UILabel!
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    private let reuseIdentifier = "accountsCollectionCell"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var feeds = [PBFeedItem]()
    var totalFeedCount = 0
    
    weak var tabContainerVC : PBTabsContainerVC? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        self.activity.isHidden = true
        self.postsNotAvailLabel.isHidden = true
        self.accountsFeedsCollectionView.isHidden = false
        
        self.connectBtn.layer.cornerRadius = 6
        if let userProfileUrlStr = UserDefaults.standard.object(forKey: "Profileurl") as? String
        {
            if let userProfileUrl = URL(string: userProfileUrlStr)
            {
                self.userProfileImage.kf.setImage(with: userProfileUrl)
            }
        }
        if let usernameStr = UserDefaults.standard.object(forKey: "UserName")
        {
            let username = "@ \(usernameStr)"
            self.usernameLabel.text = username
        }
        
        /*let connectsLabelStr = "1B CONNECTS"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: connectsLabelStr as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 12.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "AvenirNext-Medium", size: 12.0)!, range: NSRange(location:0,length:2))
        self.connectsLabel.attributedText = myMutableString*/
        
        accountsFeedsCollectionView.delegate = self
        accountsFeedsCollectionView.dataSource = self
        let nib = UINib(nibName: NibNamed.AccountsCollectionCell.rawValue, bundle: nil)
        self.accountsFeedsCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.fontSet()
        
        self.loadMyPostsDetails()
    
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.loadMyPostsDetails()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.userDescTextView.scrollRangeToVisible(NSRange(location: 0, length: 1))
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
            self.activity.isHidden = true
                
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
                                let count = responseDict["Count"] as! Int
                                self.totalFeedCount = count
                            
                                if count == 0
                                {
                                    self.postsNotAvailLabel.isHidden = false
                                    self.accountsFeedsCollectionView.isHidden = true
                                }
                                else
                                {
                                      self.feeds.removeAll()
                                      if let resultArray = responseDict["Results"] as! [NSDictionary]!
                                      {
                                         for result in resultArray
                                         {
                                             let feedItem = PBFeedItem()
                                             feedItem.PostId = result["PostId"] as? String
                                             feedItem.UserLikeStatus = result["UserLikeStatus"] as? Int == 1 ? true : false
                                             feedItem.UserDisLikeStatus = result["UserDisLikeStatus"] as? Int == 1 ? true : false
                                             feedItem.UserName = result["UserName"] as? String
                                             feedItem.Location = result["UserName"] as? String
                                             feedItem.PostTitle = result["PostTitle"] as? String
                                             feedItem.Email = result["Email"] as? String
                                             feedItem.Description = result["Description"] as? String
                                             feedItem.CurrentLikesCount = result["CurrentLikesCount"] as? Int
                                             feedItem.CurrentDisLikesCount = result["CurrentDisLikesCount"] as? Int
                                             feedItem.Profileurl = result["Profileurl"] as? String
                                        
                                             let mediaArray = result["PostMediaData"] as! [NSDictionary]!
                                             for media in mediaArray!
                                             {
                                                 let mediaItem = PBFeedMedia()
                                                 mediaItem.PostId = media["PostId"] as? String
                                                 mediaItem.PostUrl = media["PostUrl"] as? String
                                                 mediaItem.PostThumbUrl = media["PostThumbUrl"] as? String
                                                 mediaItem.MediaType = media["MediaType"] as? String
                                                 feedItem.mediaList.append(mediaItem)
                                             }
                                        
                                             self.feeds.append(feedItem)
                                          }
                                    
                                          self.accountsFeedsCollectionView.reloadData()
                                      }
                                }
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
        /*let allLabelsfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 12
        let fontSize = floor(allLabelsfontSize)*/
        
        let screenWidth = UIScreen.main.bounds.size.width
        if screenWidth == 320
        {
            let fontSize = 9
            self.connectBtn.titleLabel?.font = self.connectBtn.titleLabel?.font.withSize(CGFloat(fontSize))
            self.usernameLabel.font = self.usernameLabel.font.withSize(11)
            self.userDescTextView.font = self.userDescTextView.font?.withSize(CGFloat(fontSize))
            self.connectsLabel.font = self.connectsLabel.font.withSize(CGFloat(fontSize))
            self.sponcersLabel.font = self.sponcersLabel.font.withSize(CGFloat(fontSize))
            self.donorsLabel.font = self.donorsLabel.font.withSize(CGFloat(fontSize))
        }
        
    }
    
   
    
    @IBAction func settingsBtnAction(_ sender: UIButton)
    {
        
        let accountSettingsVC = AccountSettingsVC(nibName: "AccountSettingsVC", bundle: nil)
        self.navigationController?.pushViewController(accountSettingsVC, animated: true)

    }
    
    @IBAction func connectBtnAction(_ sender: UIButton)
    {
        
    }
}

extension AccountsVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
         return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AccountsCollectionCell
        cell.accoutsImageView.alpha = 0
        cell.accoutsImageView.kf.setImage(with : nil)
        
        
        let feedItem = self.feeds[indexPath.row]
        let likeCount = feedItem.CurrentLikesCount!
        let mediaList = feedItem.mediaList
        if mediaList.count > 0
        {
            let firstMedia = mediaList.first!
            if let thumburlString = firstMedia.PostThumbUrl
            {
                if let thumbUrl = URL(string: thumburlString)
                {
                    cell.accoutsImageView.kf.setImage(with: thumbUrl, completionHandler: { (image, error, cacheType, imageUrl) in
                        
                        guard let img = image else
                        {
                            return
                        }
                        
                        cell.accoutsImageView.kf.setImage(with: nil)
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            let im = PBUtility.blurEffect(image: img, blurRadius : Constants.maxBlurRadius - likeCount * (Constants.maxBlurRadius / 10))
                            
                            DispatchQueue.main.async {
                                
                                cell.accoutsImageView.image = im
                                
                                UIView.animate(withDuration: 0.3, animations: {
                                    cell.accoutsImageView.alpha = 1
                                })
                            }
                        }
                    })
                }
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let selectedFeed = self.feeds[indexPath.row]
        
        let interactionVC = PBFeedsInteractionVC()
        interactionVC.feeds = self.feeds
        interactionVC.selectedFeedID = selectedFeed.PostId
        interactionVC.totalFeedCount = self.totalFeedCount
        interactionVC.scrollToIndexPath = indexPath
        interactionVC.fromWhichVC = "AccountsVC"
        
        self.navigationController?.pushViewController(interactionVC, animated: true)
    }
}
