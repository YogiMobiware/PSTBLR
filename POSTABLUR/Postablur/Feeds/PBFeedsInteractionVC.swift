//
//  PBFeedsInteractionVC.swift
//  Postablur
//
//  Created by Yogi on 23/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation

class PBFeedsInteractionVC : UIViewController
{
    @IBOutlet var feedsTableView : UITableView!
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var userNameLbl : UILabel!
    
    @IBOutlet var activity : UIActivityIndicatorView!
    private let reuseIdentifier = "feedsTableCell"
    var feeds = [PBFeedItem]()
    
    var totalFeedCount = 0
    var currentFeedCount = 0

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: Inits
    init()
    {
        super.init(nibName: NibNamed.PBFeedsInteractionVC.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let userProfileUrlStr = UserDefaults.standard.object(forKey: "Profileurl")
        {
            let userProfileUrl = URL(string: userProfileUrlStr as! String)!
            self.userImageView.kf.setImage(with: userProfileUrl)
        }
        
        if let userProfileName = UserDefaults.standard.object(forKey: "UserName")
        {
            userNameLbl.text = userProfileName as! String
        }
        else
        {
            userNameLbl.text = ""
        }
        
        
        self.activity.isHidden = true
        
        self.feedsTableView.delegate = self
        self.feedsTableView.dataSource = self
        
        let nib = UINib(nibName: NibNamed.PBFeedsTableCell.rawValue, bundle: nil)
        self.feedsTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        feedsTableView.reloadData()
        
    }
    
    @IBAction func refreshTapped(_ sender : UIButton)
    {
        
    }
    
    func loadFeedsFromStart()
    {
        let urlString = String(format: "%@/OthersPostsDetails", arguments: [Urls.mainUrl]);
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
                            let count = responseDict["Count"] as! Int
                            self.totalFeedCount = count
                            
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
                                
                                self.feedsTableView.reloadData()
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
    
}

extension PBFeedsInteractionVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath)  as! PBFeedTableCell
        
        cell.feedImageView.alpha = 0
        cell.feedImageView.kf.setImage(with : nil)
        
        
        let feedItem = self.feeds[indexPath.row]
        let likeCount = feedItem.CurrentLikesCount!
        let mediaList = feedItem.mediaList
        if mediaList.count > 0
        {
            let firstMedia = mediaList.first!
            if let thumburlString = firstMedia.PostThumbUrl
            {
                let thumbUrl = URL(string: thumburlString)!
                
                cell.feedImageView.kf.setImage(with: thumbUrl, completionHandler: { (image, error, cacheType, imageUrl) in
                    
                    guard let img = image else
                    {
                        return
                    }
                    
                    cell.feedImageView.kf.setImage(with: nil)
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        let im = PBUtility.blurEffect(image: img, blurRadius : Constants.maxBlurRadius - likeCount * (Constants.maxBlurRadius / 10))
                        
                        DispatchQueue.main.async {
                            
                            cell.feedImageView.image = im
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                cell.feedImageView.alpha = 1
                            })
                        }
                    }
                    
                    
                })
            }
        }
        
        return cell
    }
    
}

