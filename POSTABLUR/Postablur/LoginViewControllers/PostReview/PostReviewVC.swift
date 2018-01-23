//
//  PostReviewVC.swift
//  Postablur
//
//  Created by Saraschandra on 22/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

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
    
    @IBOutlet var descTxtLabel: UILabel!
    
    @IBOutlet var sharedOnPHLabel: UILabel!
    @IBOutlet var sharedOnTxtLabel: UILabel!
    
    @IBOutlet var donatePHLabel: UILabel!
    @IBOutlet var donateToTxtLabel: UILabel!
    
    @IBOutlet var revealedPHLabel: UILabel!
    @IBOutlet var revealedTxtLabel: UILabel!
    
    //BottomView
    @IBOutlet var bottomView: UIView!
    
    var bluredImage : UIImage!
    
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

        //let descString = "Desc: The calm"
        
        /*var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: descString as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 16.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:4))
        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Arial-Bold", size: 16.0)!, range: NSRange(location:6,length:8))
        
        descTxtLabel.attributedText = myMutableString*/
        
        let allLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 16
        let fontSize = floor(allLabelfontSize)
        self.titlePHLabel.font = self.titlePHLabel.font.withSize(fontSize)
        self.titleTxtLabel.font = self.titleTxtLabel.font.withSize(fontSize)
        self.locationPHLabel.font = self.locationPHLabel.font.withSize(fontSize)
        self.locationTxtLabel.font = self.locationTxtLabel.font.withSize(fontSize)
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
        
        let requestDict = ["PostTitle": titleTxtLabel.text!,"Location": locationTxtLabel.text!,"Description": descTxtLabel.text!,"DonatetoCharity":donateToTxtLabel.text!,"ShareYourPost":sharedOnTxtLabel.text!,"WhoRevealsPostThisPost": revealedTxtLabel.text!,"LikeLimit":"2147483647","ShareLimit":"2147483647","DonationLimit":"2147483647","UserId":""] as [String : Any]
        
        self.appdelegate.showActivityIndictor(titleString: "Facebook SignIn", subTitleString: "")
        
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            self.appdelegate.hideActivityIndicator()
            
            if error == nil
            {
                if responseObject != nil
                {
                   
                }
                else
                {
                    self.appdelegate.alert(vc: self, message: "Something went wrong", title: "Error")
                    return
                }
            }
            else
            {
                self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Error")
                return
            }
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
         _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}
