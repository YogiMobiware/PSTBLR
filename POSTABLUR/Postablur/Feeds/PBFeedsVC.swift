//
//  PBFeedsVC.swift
//  Postablur
//
//  Created by Yogi on 22/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation

class PBFeedsVC : UIViewController
{
    var homeContainerVC : PBTabsContainerVC!
    @IBOutlet var feedsCollectionView : UICollectionView!
    @IBOutlet var photoFilterButton : UIButton!
    @IBOutlet var audioFilterButton : UIButton!
    @IBOutlet var videoFilterButton : UIButton!

    private let reuseIdentifier = "feedsCollectionCell"

    
    var feeds = [String]()
    
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
        feedsCollectionView.delegate = self
        feedsCollectionView.dataSource = self
        let nib = UINib(nibName: NibNamed.PBFeedsCollectionCell.rawValue, bundle: nil)
        self.feedsCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
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
    
}

extension PBFeedsVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PBFeedsCollectionCell
        cell.feedImageView.alpha = 0
        
        return cell
        
    }
    
    
}

