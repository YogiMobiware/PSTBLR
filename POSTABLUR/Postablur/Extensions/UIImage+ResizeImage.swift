//
//  UIImage+ResizeImage.swift
//  Postablur
//
//  Created by Saraschandra on 19/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation

extension UIImage
{
    // #MARK:-- IMAGE SCALING
    public func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage?
    {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
