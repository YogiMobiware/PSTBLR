//
//  PBFeedsVC.swift
//  Postablur
//
//  Created by Yogi on 22/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation
import Kingfisher

class PBFeedsVC : UIViewController
{
    var tabContainerVC : PBTabsContainerVC!
    @IBOutlet var feedsCollectionView : UICollectionView!
    @IBOutlet var photoFilterButton : UIButton!
    @IBOutlet var audioFilterButton : UIButton!
    @IBOutlet var videoFilterButton : UIButton!

    @IBOutlet var activity : UIActivityIndicatorView!

    private let reuseIdentifier = "feedsCollectionCell"

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var feeds = [PBFeedItem]()
    var totalFeedCount = 0
    
    // MARK: Inits
    init()
    {
        super.init(nibName: NibNamed.PBFeedsVC.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.activity.isHidden = true
        
        feedsCollectionView.delegate = self
        feedsCollectionView.dataSource = self
        let nib = UINib(nibName: NibNamed.PBFeedsCollectionCell.rawValue, bundle: nil)
        self.feedsCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        loadFeedsFromStart()
    }
    
    @IBAction func filterButtonTapped(_ sender : UIButton)
    {
        switch sender
        {
        case self.photoFilterButton :
            break
            
        case self.audioFilterButton :
            break
            
        case self.videoFilterButton:
            break
            
        default:
            break
        }
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
                                
                                self.feedsCollectionView.reloadData()
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

extension PBFeedsVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PBFeedsCollectionCell
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

extension PBFeedsVC : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}

