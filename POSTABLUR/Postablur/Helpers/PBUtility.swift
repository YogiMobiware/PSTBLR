//
//  PBUtility.swift
//  Postablur
//
//  Created by Abhignya on 21/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation

class PBUtility : NSObject
{
    class func showSimpleAlertForVC(vc : UIViewController, withTitle title : String, andMessage message : String)
    {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func flipImage(image: UIImage) -> UIImage
    {
        guard let cgImage = image.cgImage else {
            return image
        }
        
        let flippedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
        
        return flippedImage
    }
}

