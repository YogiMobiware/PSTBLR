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
    
    class func blurEffect(image : UIImage) -> UIImage {
        
        let context = CIContext()
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(50, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage.init(cgImage: cgimg!, scale: image.scale, orientation: image.imageOrientation)
        
        return processedImage
    }
}

