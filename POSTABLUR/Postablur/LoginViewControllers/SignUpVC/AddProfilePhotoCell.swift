//
//  AddProfilePhotoCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/18/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

protocol AddProfilePhotoCellDelegate
{
    
    func pbCaptureAPhotoImageDidTap(capturedPhotoWidth: CGFloat,capturedPhotoHeight: CGFloat)
    
    func pbUploadAPhotoImageDidTap(uploadPhotoWidth: CGFloat,uploadPhotoHeight: CGFloat)

}
class AddProfilePhotoCell: UITableViewCell
{

    @IBOutlet var captureImageView: UIImageView!
    @IBOutlet var uploadImageView: UIImageView!
    var delegate : AddProfilePhotoCellDelegate? = nil

    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        let tapRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddProfilePhotoCell.captureImageAction))
        self.captureImageView.addGestureRecognizer(tapRecogniser)
        
        let uploadTapRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddProfilePhotoCell.UploadImageAction))
        self.uploadImageView.addGestureRecognizer(uploadTapRecogniser)
        


    }

    @objc func captureImageAction()
    {
        if let delegate = self.delegate
        {
            delegate.pbCaptureAPhotoImageDidTap(capturedPhotoWidth: captureImageView.frame.width, capturedPhotoHeight: captureImageView.frame.height)
        }
    }
    @objc func UploadImageAction()
    {
        if let delegate = self.delegate
        {
            delegate.pbUploadAPhotoImageDidTap(uploadPhotoWidth: uploadImageView.frame.width, uploadPhotoHeight: uploadImageView.frame.height)

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectedImageViewType(image : UIImage ,imageType : String)
    {
        
        if imageType == UploadedImageType.CapturedPhotoFromCamera.rawValue
        {
//            self.captureImageView?.layer.cornerRadius = self.captureImageView!.frame.size.height / 2
//            self.captureImageView?.clipsToBounds = true
//            self.captureImageView?.layer.masksToBounds = true
            captureImageView.image = image
            uploadImageView.image = nil
        }
        else
        {
//            self.uploadImageView?.clipsToBounds = true
//            self.uploadImageView?.layer.cornerRadius = self.uploadImageView!.frame.size.height / 2
//            self.uploadImageView?.layer.masksToBounds = true
            uploadImageView.image = image
            captureImageView.image = nil

            
        }
    }
}

