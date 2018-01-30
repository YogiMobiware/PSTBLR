//
//  PostReviewVC.swift
//  Postablur
//
//  Created by Saraschandra on 22/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
import Alamofire

class PostReviewVC: UIViewController
{
    //TopView
    @IBOutlet var topView: UIView!
    @IBOutlet var backBtn: UIButton!
    
    //ImageView
    @IBOutlet var imageBackView: UIView!
    @IBOutlet var selectedImageView: UIImageView!
    
    //LabelsView
    @IBOutlet var labelsBackView: UIView!
    
    @IBOutlet var titlePHLabel: UILabel!
    @IBOutlet var titleTxtLabel: UILabel!
    
    @IBOutlet var locationPHLabel: UILabel!
    @IBOutlet var locationTxtLabel: UILabel!
    
    @IBOutlet var descPHLabel: UILabel!
    @IBOutlet var descTxtLabel: UILabel!
    
    @IBOutlet var sharedOnPHLabel: UILabel!
    @IBOutlet var sharedOnTxtLabel: UILabel!
    
    @IBOutlet var donatePHLabel: UILabel!
    @IBOutlet var donateToTxtLabel: UILabel!
    
    @IBOutlet var revealedPHLabel: UILabel!
    @IBOutlet var revealedTxtLabel: UILabel!
    
    //BottomView
    @IBOutlet var bottomView: UIView!
    
    
    var appdelegate : AppDelegate!
    @IBOutlet weak var postTile_Label : UILabel!

    //ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostReviewVC.tapGestureRecognized))
        self.bottomView.addGestureRecognizer(tapRecogniser)
        
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let shareLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 24
        let roundedBoldfontSize = floor(shareLabelfontSize)
        self.postTile_Label.font = self.postTile_Label.font.withSize(roundedBoldfontSize)

        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("1.jpg"))
        let blurredImage    = UIImage(contentsOfFile: imgPath.path)

        selectedImageView.image =  PBUtility.blurEffect(image: blurredImage!)

        
        let allLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 16
        let fontSize = floor(allLabelfontSize)
        self.titlePHLabel.font = self.titlePHLabel.font.withSize(fontSize)
        self.titleTxtLabel.font = self.titleTxtLabel.font.withSize(fontSize)
        self.locationPHLabel.font = self.locationPHLabel.font.withSize(fontSize)
        self.locationTxtLabel.font = self.locationTxtLabel.font.withSize(fontSize)
        self.descPHLabel.font = self.descPHLabel.font.withSize(fontSize)
        self.descTxtLabel.font = self.descTxtLabel.font.withSize(fontSize)
        self.sharedOnPHLabel.font = self.sharedOnPHLabel.font.withSize(fontSize)
        self.sharedOnTxtLabel.font = self.sharedOnTxtLabel.font.withSize(fontSize)
        self.donatePHLabel.font = self.donatePHLabel.font.withSize(fontSize)
        self.donateToTxtLabel.font = self.donateToTxtLabel.font.withSize(fontSize)
        self.revealedPHLabel.font = self.revealedPHLabel.font.withSize(fontSize)
        self.revealedTxtLabel.font = self.revealedTxtLabel.font.withSize(fontSize)
       
    }
    
    @objc internal func tapGestureRecognized()
    {
        print("Tapped")
        
        let urlString = String(format: "%@/AddUserPost", arguments: [Urls.mainUrl]);
        if let userID = UserDefaults.standard.string(forKey: "UserId") {

        let requestDict = ["PostTitle": titleTxtLabel.text!,"Location": locationTxtLabel.text!,"Description": descTxtLabel.text!,"DonatetoCharity":"1","ShareYourPost":"10","WhoRevealsPostThisPost": "Public","LikeLimit":"10","ShareLimit":"10","DonationLimit":"2147","UserId":userID] as [String : Any]
        
        self.appdelegate.showActivityIndictor(titleString: "Postablur", subTitleString: "Posting...")

        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            if error == nil
            {
                if responseObject != nil
                {
                   
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        if let resultArray = responseDict["Results"] as! [NSDictionary]!
                        {
                        
                            let result = resultArray.first!
                            
                            let statusCode = result["StatusCode"] as! String
                            let postID = result["PostId"] as! String
                            if statusCode == "0"
                            {
                            self.appdelegate.hideActivityIndicator()

                            self.uploadBlurredImageToServer(postID: postID)

                            }
                        
                        }
                    }
                    
                }
                else
                {
                    PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Error", andMessage: "Something went wrong")
                    self.appdelegate.hideActivityIndicator()

                    return
                }
            }
            else
            {
                PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Error", andMessage: (error?.localizedDescription)!)
                self.appdelegate.hideActivityIndicator()

                return
            }
        }
        
    }
    
    }
    func uploadBlurredImageToServer(postID : String)
    {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("1.jpg"))

        let image    = UIImage(contentsOfFile: imgPath.path)

        let resizedImage = image?.resizeImage(image: image!, newWidth: (image?.size.width)!*0.5)!

        let parameters : [String: String] = ["Mediatype":"1","postID":postID]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(resizedImage!, 1.0)!, withName: "UploadPhoto", fileName: "UploadImage.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:Urls.uploadPostMediaUrl)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                self.appdelegate.showActivityIndictor(titleString: "Uploading...", subTitleString: "")

                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    
                })
                
                upload.responseJSON { response in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")

                        if let responseDict = JSON as? [String : AnyObject]
                        {
                            if let _ = responseDict["RetrurnUrl"] as! String!
                            {
                               self.showUploadSuccessAlert()
                                self.appdelegate.hideActivityIndicator()

                            }
                        }
                        else
                        {
                            let responseDict = JSON as? [String : AnyObject]
                            self.appdelegate.alert(vc: self, message: responseDict!["StatusMsg"] as! String!, title: "Error Uploading")
                            self.appdelegate.hideActivityIndicator()

                        }
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                self.appdelegate.hideActivityIndicator()
            }
        }
    }
    
    func showUploadSuccessAlert(){
        
        let alertView = UIAlertController(title: "Postablur", message: "Uploaded Successfully", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
            
            self.appdelegate.needToReloadFeeds = true
            
            self.dismiss(animated: true, completion: nil)

        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)

    }
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
         _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}
