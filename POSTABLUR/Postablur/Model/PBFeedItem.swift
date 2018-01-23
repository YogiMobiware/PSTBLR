//
//  PBFeedItem.swift
//  Postablur
//
//  Created by Abhignya on 23/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation

class PBFeedItem : NSObject
{
    var PostId : String?
    var UserLikeStatus : Bool?
    var UserDisLikeStatus : Bool?
    var UserName : String?
    var Location : String?
    var PostTitle : String?
    var Email : String?
    var Description : String?
    var CurrentDisLikesCount : Int?
    var CurrentLikesCount : Int?
    var Profileurl : String?
    var mediaList : [PBFeedMedia] = [PBFeedMedia]()
}
