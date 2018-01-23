//
//  PBFeedsInteractionVC.swift
//  Postablur
//
//  Created by Abhignya on 23/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation

class PBFeedsInteractionVC : UIViewController
{
    @IBOutlet var feedsCollectionView : UITableView!
    
    @IBOutlet var activity : UIActivityIndicatorView!
    private let reuseIdentifier = "feedsTableCell"
    var feeds = [PBFeedItem]()
    
    var totalFeedCount = 0
    
    // MARK: Inits
    init()
    {
        super.init(nibName: NibNamed.PBFeedsInteractionVC.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
