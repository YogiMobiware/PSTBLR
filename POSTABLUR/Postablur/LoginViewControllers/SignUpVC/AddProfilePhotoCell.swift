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
    @IBOutlet var selectedImageFromPhoto: UIImageView!
    @IBOutlet var capturedImagefromCamera: UIImageView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        let tapRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddProfilePhotoCell.captureImageAction))
        self.capturedImagefromCamera.addGestureRecognizer(tapRecogniser)
        
        let uploadTapRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddProfilePhotoCell.UploadImageAction))
        self.selectedImageFromPhoto.addGestureRecognizer(uploadTapRecogniser)
        
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
            self.capturedImagefromCamera?.layer.cornerRadius = self.capturedImagefromCamera!.frame.size.width / 2
            self.capturedImagefromCamera?.clipsToBounds = true
            self.capturedImagefromCamera?.layer.masksToBounds = true
           self.capturedImagefromCamera.image = image
            self.captureImageView.image = nil
            self.uploadImageView.image = UIImage.init(named: "userGreyUploadPhotoIcon")

        }
        else
        {
            self.selectedImageFromPhoto?.layer.cornerRadius = self.selectedImageFromPhoto!.frame.size.width / 2
            self.selectedImageFromPhoto?.clipsToBounds = true
            self.selectedImageFromPhoto?.layer.masksToBounds = true
            self.selectedImageFromPhoto.image = image
            self.uploadImageView.image = nil
            self.captureImageView.image = UIImage.init(named: "createGreyIconPostablurApp")

            
        }
    }
}

