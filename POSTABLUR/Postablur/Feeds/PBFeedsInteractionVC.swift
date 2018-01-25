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
    var scrollToIndexPath : IndexPath? = nil
    
    var isLoadingFeeds = false
    var selectedFeedID : String? = nil
    
    var totalFeedCount = 0
    var currentFeedCount = 0
    
    var fromWhichVC : String!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var reportAbuseVC : ReportAbuseVC!

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
        
        
        
        if let userProfileUrlStr = UserDefaults.standard.object(forKey: "Profileurl") as? String
        {
            if let userProfileUrl = URL(string: userProfileUrlStr)
            {
                self.userImageView.kf.setImage(with: userProfileUrl)
            }
            else
            {
                self.userImageView.image = UIImage.init(named: "default_avatar")
            }
        }
        
        if let userProfileName = UserDefaults.standard.object(forKey: "UserName")
        {
            userNameLbl.text = "@\(userProfileName as! String)"
        }
        else
        {
            userNameLbl.text = ""
        }
        
        
        self.moveSelectedFeedToFirstPosition()
        
        
        reportAbuseVC = ReportAbuseVC(nibName: "ReportAbuseVC", bundle: nil)

        self.activity.isHidden = true
        
        self.feedsTableView.delegate = self
        self.feedsTableView.dataSource = self
        
        let nib = UINib(nibName: NibNamed.PBFeedTableCell.rawValue, bundle: nil)
        self.feedsTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        feedsTableView.reloadData()
//        self.feedsTableView.layoutIfNeeded()
//
//        if let indexPathToScrollTo = self.scrollToIndexPath
//        {
//            let indexPath = IndexPath(item: indexPathToScrollTo.row, section: 0)
//            self.feedsTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
//        }
        
      
        
    }
    
    
 
    func moveSelectedFeedToFirstPosition()
    {
        let selectedFeedsArray = self.feeds.filter { (feedItem) -> Bool in
            
            return feedItem.PostId == self.selectedFeedID
        }
        
        if(selectedFeedsArray.count > 0)
        {
            let selectedFeed = selectedFeedsArray.first!
            self.feeds.remove(at: self.feeds.index(of: selectedFeed)!)
            self.feeds.insert(selectedFeed, at: 0)
        }
    }
    
    @IBAction func refreshTapped(_ sender : UIButton)
    {
        self.loadFeedsFromStart(count : self.feeds.count)
    }
    
    @IBAction func backTapped(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadFeedsFromStart(count : Int = 20)
    {
        var urlString : String!
        
        if fromWhichVC == "AccountsVC"
        {
            urlString = String(format: "%@/OthersPostsDetails", arguments: [Urls.mainUrl]);
        }
        else if fromWhichVC == "PBFeedsVC"
        {
            urlString = String(format: "%@/MyPostsDetails", arguments: [Urls.mainUrl])
        }
        else
        {
            print("No serivce call happend")
        }
        
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else
        {
            return
        }
        
        let startIndex = "1"
        let endIndex  =  String(Constants.feedPageSize)
        let requestDict = ["UserId": userId,"StartValue": startIndex,"Endvalue": endIndex] as [String : Any]
        
        self.activity.startAnimating()
        self.activity.isHidden = false
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            
            if error == nil
            {
                if responseObject != nil
                {
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        
                        if let error = responseDict["Error"] as? String
                        {
                            self.activity.stopAnimating()
                            self.appDelegate.alert(vc: self, message: error , title: "Error")
                            return
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
                                    
                                    let count = result["TotalCount"] as! Int
                                    self.totalFeedCount = count
                                    self.feeds.append(feedItem)
                                }
                                
                                if self.feeds.count <= 0
                                {
                                    self.activity.stopAnimating()
//                                    self.noFeedsLbl.isHidden = false
                                }
                                self.moveSelectedFeedToFirstPosition()
                                self.feedsTableView.reloadData()
                            }
                        }
                        
                    }
                    if let responseStr = responseObject as? String
                    {
                        self.activity.stopAnimating()
                        self.appDelegate.alert(vc: self, message: responseStr, title: "Error")
                        return
                    }
                    
                }
                else
                {
                    self.activity.stopAnimating()
                    self.appDelegate.alert(vc: self, message: "Something went wrong", title: "Error")
                    return
                }
            }
            else
            {
                self.activity.stopAnimating()
                self.appDelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Error")
                return
            }
        }
    }
    
    
    func loadFeedsMore()
    {
        var urlString : String!
        
        if fromWhichVC == "AccountsVC"
        {
            urlString = String(format: "%@/OthersPostsDetails", arguments: [Urls.mainUrl]);
        }
        else if fromWhichVC == "PBFeedsVC"
        {
            urlString = String(format: "%@/MyPostsDetails", arguments: [Urls.mainUrl])
        }
        else
        {
            print("No serivce call happend")
        }
        
        //let urlString = String(format: "%@/OthersPostsDetails", arguments: [Urls.mainUrl]);
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else
        {
            return
        }
        
        let startIndex = String(self.feeds.count + 1)
        let endIndex  =  String(self.feeds.count + Constants.loadMoreFeedPageSize)
        
        let requestDict = ["UserId": userId,"StartValue": startIndex,"Endvalue": endIndex] as [String : Any]
        
        self.activity.startAnimating()
        self.activity.isHidden = false
        
        self.isLoadingFeeds = true
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            self.isLoadingFeeds = false
            
            if error == nil
            {
                if responseObject != nil
                {
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        
                        if let error = responseDict["Error"] as? String
                        {
                            self.activity.stopAnimating()
                            self.appDelegate.alert(vc: self, message: error , title: "Error")
                            return
                        }
                        else
                        {

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
                                    
                                    let count = result["TotalCount"] as! Int
                                    self.totalFeedCount = count
                                    self.feeds.append(feedItem)
                                }
                                
                                if self.feeds.count <= 0
                                {
                                    self.activity.stopAnimating()
                                }
                                self.moveSelectedFeedToFirstPosition()
                                self.feedsTableView.reloadData()
                            }
                        }
                        
                    }
                    if let responseStr = responseObject as? String
                    {
                        self.activity.stopAnimating()
                        self.appDelegate.alert(vc: self, message: responseStr, title: "Error")
                        return
                    }
                    
                }
                else
                {
                    self.activity.stopAnimating()
                    self.appDelegate.alert(vc: self, message: "Something went wrong", title: "Error")
                    return
                }
            }
            else
            {
                self.activity.stopAnimating()
                self.appDelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Error")
                return
            }
        }
    }
    
    
    func callLikeApi(like : Bool, forFeedItem feedItem : PBFeedItem)
    {
        let urlString = String(format: "%@/PostLike", arguments: [Urls.mainUrl]);
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else
        {
            return
        }
        guard let postId = feedItem.PostId else
        {
            return
        }
        
        let requestDict = ["UserId": userId,"PostId": postId, "Like" : like == true ? 1 : 0] as [String : Any]
        
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
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
                            ///reloadIndexPath
                            if let index = self.feeds.index(of: feedItem)
                            {
                                if let resultArray = responseDict["Results"] as! [NSDictionary]!
                                {
                                    if resultArray.count > 0
                                    {
                                        let likeResult = resultArray.first!
                                        
                                        if let currentTotalLikesCount = likeResult["CurrentCount"] as? Int
                                        {
                                            feedItem.CurrentLikesCount = currentTotalLikesCount
                                        }
                                        
                                    }
                                    
                                    feedItem.UserLikeStatus = like
                                    let indexPath = IndexPath(row: index, section: 0)
                                    self.feedsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

                                   
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
    
    func callDislikeApi(dislike : Bool, forFeedItem feedItem : PBFeedItem)
    {
        let urlString = String(format: "%@/PostDisLike", arguments: [Urls.mainUrl]);
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else
        {
            return
        }
        guard let postId = feedItem.PostId else
        {
            return
        }
        
        let requestDict = ["UserId": userId,"PostId": postId, "DisLike" : dislike == true ? 1 : 0] as [String : Any]
        
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
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
                            ///reloadIndexPath
                            if let index = self.feeds.index(of: feedItem)
                            {
                                if let resultArray = responseDict["Results"] as! [NSDictionary]!
                                {
                                    if resultArray.count > 0
                                    {
                                        let dislikeResult = resultArray.first!
                                        
                                        if let currentTotaldisLikesCount = dislikeResult["CurrentCount"] as? Int
                                        {
                                            feedItem.CurrentDisLikesCount = currentTotaldisLikesCount
                                        }
                                        
                                    }
                                    feedItem.UserDisLikeStatus = dislike
                                    
                                    let indexPath = IndexPath(row: index, section: 0)
                                    self.feedsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                                    
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
    
    
}

extension PBFeedsInteractionVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 515
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath)  as! PBFeedTableCell
        
        cell.delegate = self
        
        cell.selectionStyle = .none
        cell.postTitleLbl.text = nil
        cell.postLocationLbl.text = nil
//        cell.postViewsCountLbl.text = nil
//        cell.postTimeElapsedLbl.text = nil
        cell.postUsernameLbl.text = nil
        cell.postDescriptionLbl.text = nil
        cell.postLikesCountLbl.text = nil
        cell.postDislikesCountLbl.text = nil
        
        
        
        cell.feedImageView.alpha = 0
        
        
        let feedItem = self.feeds[indexPath.row]
        
        let likeCount = feedItem.CurrentLikesCount!
        let dislikeCount = feedItem.CurrentDisLikesCount!
        let title = feedItem.PostTitle!
        let description = feedItem.Description!
        let location = feedItem.Location!
        let username = feedItem.UserName!
        let hasUserLiked = feedItem.UserLikeStatus
        let hasUserDisliked = feedItem.UserDisLikeStatus
        
        cell.postLikesCountLbl.text = "\(likeCount) likes"
        cell.postDislikesCountLbl.text = "\(dislikeCount) dislikes"
        cell.postDescriptionLbl.text = description
        cell.postTitleLbl.text = title
        cell.postLocationLbl.text = location
        cell.postUsernameLbl.text = "@\(username)"
        
        if hasUserLiked == true
        {
            cell.postLikeBtn.isSelected = true
            cell.postLikeBtn.tintColor = Constants.navBarTintColor
        }
        else
        {
            cell.postLikeBtn.isSelected = false
            cell.postLikeBtn.tintColor = Constants.greyTintColor
        }
        
        if hasUserDisliked == true
        {
            cell.postDislikeBtn.isSelected = true
            cell.postDislikeBtn.tintColor = Constants.navBarTintColor
        }
        else
        {
            cell.postDislikeBtn.isSelected = false
            cell.postDislikeBtn.tintColor = Constants.greyTintColor
        }
        
        cell.postShareBtn.tintColor = Constants.greyTintColor
        cell.postDonateBtn.tintColor = Constants.greyTintColor


        cell.postLikeBtn.isEnabled = true
        cell.postDislikeBtn.isEnabled = true
        
        let mediaList = feedItem.mediaList
        if mediaList.count > 0
        {
            let firstMedia = mediaList.first!
            if let urlString = firstMedia.PostUrl
            {
                if let postPicUrl = URL(string: urlString)
                {
                    cell.feedImageView.kf.setImage(with: postPicUrl, completionHandler: { (image, error, cacheType, imageUrl) in
                        
                        guard let img = image else
                        {
                            cell.feedImageView.kf.setImage(with: nil)
                            self.activity.stopAnimating()
                            return
                        }
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            let im = PBUtility.blurEffect(image: img, blurRadius : Constants.maxBlurRadius - likeCount * (Constants.maxBlurRadius / 10))
                            
                            DispatchQueue.main.async {
                                
                                self.activity.stopAnimating()
                                cell.feedImageView.image = im
                                
                                UIView.animate(withDuration: 0.3, animations: {
                                    cell.feedImageView.alpha = 1
                                })
                            }
                        }
                        
                        
                    })
                }
                else
                {
                    cell.feedImageView.kf.setImage(with: nil)
                }
                
               
            }
            else
            {
                cell.feedImageView.kf.setImage(with: nil)
            }
        }
        else
        {
            cell.feedImageView.kf.setImage(with: nil)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.activity.stopAnimating()
        
        
        if indexPath.row == self.feeds.count - 1
        {
            guard self.totalFeedCount > self.feeds.count else
            {
                return
            }
            if self.isLoadingFeeds == false
            {
                self.loadFeedsMore()
            }
        }
    }
}

extension PBFeedsInteractionVC : ReportAbuseVCDelegate
{
    
    func pbDidTapOnCancel(){
        
         self.reportAbuseVC.view.removeFromSuperview()
        
    }
    func reportAbuseSubmitDidTap()
    {
        
        
    }
    
    
}

extension PBFeedsInteractionVC : PBFeedTableCellDelegate
{
    func pbFeedTableCell(cell: PBFeedTableCell, didSelectAction action: PBFeedAction) {
        
        if let indexPath = self.feedsTableView.indexPath(for: cell)
        {
            let feed = self.feeds[indexPath.row]
            
            switch action
            {
            case .like:
                
                cell.postLikeBtn.isEnabled = false
                
                if let userLikedPost = feed.UserLikeStatus as? Bool, userLikedPost == true
                {
                    /// need to unlike post
                    self.callLikeApi(like: false, forFeedItem: feed)
                }
                else
                {
                    /// need to like post
                    self.callLikeApi(like: true, forFeedItem: feed)
                }
                
                
                break
                
            case .dislike:
                
                cell.postDislikeBtn.isEnabled = false
                
                if let userDisLikedPost = feed.UserDisLikeStatus as? Bool, userDisLikedPost == true
                {
                    /// need to undislike post
                    self.callDislikeApi(dislike: false, forFeedItem: feed)
                }
                else
                {
                    /// need to dislike post
                    self.callDislikeApi(dislike: true, forFeedItem: feed)
                }
                
                break
                
            case .share:
                break
                
            case .donate:
                
                let childView = reportAbuseVC.view
                childView?.frame =  CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.addChildViewController(reportAbuseVC)
                reportAbuseVC.didMove(toParentViewController: self)
                reportAbuseVC.delegate = self
                reportAbuseVC.abusePostID = feed.PostId
                self.view.addSubview(childView!)
                
                break
            }
        }
    }
}


