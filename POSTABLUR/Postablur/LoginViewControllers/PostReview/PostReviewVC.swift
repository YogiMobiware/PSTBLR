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
        
        /* attributes1 = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!,
                          NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        
        let attributes2 = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!,
                           NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        
        let attrString1 = NSAttributedString(string: "Title: ", attributes: attributes1)
        let attrString2 = NSAttributedString(string: "FRONT STAGE MELE: ", attributes: attributes2)*/
        
        let shareLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 24
        let roundedBoldfontSize = floor(shareLabelfontSize)
        self.postTile_Label.font = self.postTile_Label.font.withSize(roundedBoldfontSize)

        
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
