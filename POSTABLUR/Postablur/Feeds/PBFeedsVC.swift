//
//  PBFeedsVC.swift
//  Postablur
//
//  Created by Yogi on 22/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation
import Kingfisher
import Toast_Swift

class PBFeedsVC : UIViewController
{
    var tabContainerVC : PBTabsContainerVC!
    @IBOutlet var feedsCollectionView : UICollectionView!
    @IBOutlet var photoFilterButton : UIButton!
    @IBOutlet var audioFilterButton : UIButton!
    @IBOutlet var videoFilterButton : UIButton!

    @IBOutlet var activity : UIActivityIndicatorView!
    @IBOutlet var noFeedsLbl : UILabel!

    var blurOperations = [IndexPath : BlockOperation]()
    let blurOperationsQueue = OperationQueue()
    
    let reuseIdentifier = "feedsCollectionCell"

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var feeds = [PBFeedItem]()
    var totalFeedCount = 0
    
    var isLoadingFeeds = false
    
    var style = ToastStyle()
    
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
        
        self.style.messageColor = .white
        
        self.activity.isHidden = true
        self.noFeedsLbl.isHidden = true

        feedsCollectionView.delegate = self
        feedsCollectionView.dataSource = self
        let nib = UINib(nibName: NibNamed.PBFeedsCollectionCell.rawValue, bundle: nil)
        self.feedsCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        blurOperationsQueue.maxConcurrentOperationCount = 3
        
        loadFeedsFromStart()
    }
    
    deinit {
        
        blurOperationsQueue.cancelAllOperations()
        blurOperations.removeAll()
    }
    
    
    @IBAction func filterButtonTapped(_ sender : UIButton)
    {
        switch sender
        {
        case self.photoFilterButton :
            break
            
        case self.audioFilterButton :
            
            self.view.makeToast("Stats coming soon...", duration: 3.0, position: .center, style: style)
            //self.appDelegate.alert(vc: self, message: "Stats coming soon...", title: "Error")
            break
            
        case self.videoFilterButton:
            
            self.view.makeToast("Stats coming soon...", duration: 3.0, position: .center, style: style)
            //self.appDelegate.alert(vc: self, message: "Stats coming soon...", title: "Error")
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
        
        let startIndex = "1"
        let endIndex  =  String(Constants.feedPageSize)
        
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
                                    self.noFeedsLbl.isHidden = false
                                    self.feedsCollectionView.isHidden = true
                                }
                                else
                                {
                                    self.noFeedsLbl.isHidden = true
                                    self.feedsCollectionView.isHidden = false
                                }
                                
                                self.feedsCollectionView.reloadData()
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
        let urlString = String(format: "%@/OthersPostsDetails", arguments: [Urls.mainUrl]);
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
                                    self.noFeedsLbl.isHidden = false
                                    self.feedsCollectionView.isHidden = true
                                }
                                else
                                {
                                    self.noFeedsLbl.isHidden = true
                                    self.feedsCollectionView.isHidden = false
                                }
                                
                                self.feedsCollectionView.reloadData()
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
    
    func saveImage(image : UIImage, withName name : String)
    {
        if let data = UIImageJPEGRepresentation(image, 0.7) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(name)")
            try? data.write(to: filename)
        }
    }
    
    func getImage(withName name : String) -> UIImage?
    {
        let fileManager = FileManager.default
        let imagePAth = self.getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        if fileManager.fileExists(atPath: imagePAth.path){
            let image =  UIImage(contentsOfFile: imagePAth.path)
            return image
        }else{
            return nil
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}

extension PBFeedsVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PBFeedsCollectionCell
//        cell.feedImageView.alpha = 0
//        cell.feedImageView.kf.setImage(with : nil)
        
        
        let feedItem = self.feeds[indexPath.row]
        let likeCount = feedItem.CurrentLikesCount!
        
        var cachedImgFound = false
        if let savedImg  = self.getImage(withName: "sfi\(feedItem.PostId!)_\(feedItem.CurrentLikesCount!).jpg")
        {
            cell.feedImageView.image =  savedImg
            cell.feedImageView.alpha = 1
            cachedImgFound = true
        }
        
        guard cachedImgFound == false else
        {
            return cell
        }
        
        cell.feedImageView.alpha = 0
        
        let mediaList = feedItem.mediaList

        if mediaList.count > 0
        {
            let firstMedia = mediaList.first!
            if let thumburlString = firstMedia.PostThumbUrl
            {
                if let thumbUrl = URL(string: thumburlString)
                {
                    cell.feedImageView.kf.setImage(with: thumbUrl, completionHandler: { (image, error, cacheType, imageUrl) in
                        
                        
                        guard let img = image else
                        {
                            cell.feedImageView.kf.setImage(with: nil)
                            self.activity.stopAnimating()
                            return
                        }
                        
                        let blurOperation = BlockOperation()
                        weak var weakOperation = blurOperation
                        weak var weakSelf = self
                        blurOperation.addExecutionBlock {
                            
                            let im = PBUtility.blurEffect(image: img, blurRadius : Constants.maxBlurRadius - likeCount * (Constants.maxBlurRadius / 10))
                            
                             self.saveImage(image: im, withName : "sfi\(feedItem.PostId!)_\(feedItem.CurrentLikesCount!)")
                            
                            OperationQueue.main.addOperation {
                                
                                guard let operation = weakOperation else
                                {
                                    return
                                }
                                
                                if (operation.isCancelled == false)
                                {
                                    guard weakSelf != nil else
                                    {
                                        return
                                    }
                                    weakSelf!.activity.stopAnimating()
                                    cell.feedImageView.image = im
                                    cell.feedImageView.alpha = 1
                                    weakSelf!.blurOperations.removeValue(forKey: indexPath)
                                    
                                }
                            }
                            
                        }
                        
                        self.blurOperations[indexPath] = blurOperation
                        self.blurOperationsQueue.addOperation(blurOperation)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedFeed = self.feeds[indexPath.row]
        
        let interactionVC = PBFeedsInteractionVC()
        interactionVC.feeds = self.feeds
        interactionVC.selectedFeedID = selectedFeed.PostId
        interactionVC.totalFeedCount = self.totalFeedCount
        interactionVC.scrollToIndexPath = indexPath
        interactionVC.fromWhichVC = "PBFeedsVC"
        
        self.navigationController?.pushViewController(interactionVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let indexPaths = collectionView.indexPathsForVisibleItems
            guard indexPaths.count > 0 else
            {
                self.blurOperations.removeAll()
                self.blurOperationsQueue.cancelAllOperations()
                return
            }
            let matchingVisibleIndPaths = indexPaths.filter({ (inPath) -> Bool in
                
                return inPath == indexPath
            })
        
            if matchingVisibleIndPaths.count == 0
            {
                let ongoingBlurOperation = self.blurOperations[indexPath]
                if (ongoingBlurOperation != nil)
                {
                    ongoingBlurOperation?.cancel()
                    self.blurOperations.removeValue(forKey: indexPath)
                }
                return
            }
        
    }
}

extension PBFeedsVC : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}

