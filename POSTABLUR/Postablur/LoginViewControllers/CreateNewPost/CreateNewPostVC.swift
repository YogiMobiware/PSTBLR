//
//  CreateNewPostVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/22/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
import Alamofire

class CreateNewPostVC: UIViewController
{
   
    @IBOutlet weak var createPostTableView: UITableView!
    @IBOutlet weak var postTitleLabel : UILabel!
    var descriptionTextView : String? = nil
    var titleLabelText : String? = nil
    var locationText : String? = nil
    var postTosocialNetwork : String? = nil
    var donateToCharity : String? = nil
    var whoGetsToReveal : String? = nil
    var appdelegate : AppDelegate!
    var selectedLikeLimitCount : String? = nil

    var cell = DescriptionCell()
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

        let titleNib = UINib(nibName: NibNamed.TitleCell.rawValue, bundle: nil)
        self.createPostTableView.register(titleNib, forCellReuseIdentifier: CellIdentifiers.TitleCellIdentifier.rawValue)
        
        let locationNib = UINib(nibName: NibNamed.LocationCell.rawValue, bundle: nil)
        self.createPostTableView.register(locationNib, forCellReuseIdentifier: CellIdentifiers.LocationCellIdentifier.rawValue)
        
        let descriptionNib = UINib(nibName: NibNamed.DescriptionCell.rawValue, bundle: nil)
        self.createPostTableView.register(descriptionNib, forCellReuseIdentifier: CellIdentifiers.DescriptionCellIdentifier.rawValue)
       
        let shareYourPostNib = UINib(nibName: NibNamed.ShareYourPost.rawValue, bundle: nil)
        self.createPostTableView.register(shareYourPostNib, forCellReuseIdentifier: CellIdentifiers.ShareYourPostCellIdentifier.rawValue)

        let blurNib = UINib(nibName: NibNamed.BlurImageCell.rawValue, bundle: nil)
        self.createPostTableView.register(blurNib, forCellReuseIdentifier: CellIdentifiers.BlurImageCellIdentifier.rawValue)

        let shareLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 24
        let roundedBoldfontSize = floor(shareLabelfontSize)
        self.postTitleLabel.font = self.postTitleLabel.font.withSize(roundedBoldfontSize)


        self.appdelegate = UIApplication.shared.delegate as! AppDelegate

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
   
    }
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func doneBtnAction(_ sender: UIButton)
    {
        guard let _ = self.titleLabelText, !(self.titleLabelText?.isEmpty)! else {
            PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Postablur", andMessage: "Please enter post title")
            return
        }
        guard let _ = self.locationText, !(self.locationText?.isEmpty)! else {
            PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Postablur", andMessage: "Location should not be empty")
            return
        }
        guard let _ = self.descriptionTextView, !(self.descriptionTextView?.isEmpty)! else {
            PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Postablur", andMessage: "Please enter post description")
            return
        }
            print("Tapped")
            
            let urlString = String(format: "%@/AddUserPost", arguments: [Urls.mainUrl]);
            if let userID = UserDefaults.standard.string(forKey: "UserId") {
                
                let requestDict = ["PostTitle": self.titleLabelText!,"Location": self.locationText!,"Description": self.descriptionTextView!,"DonatetoCharity":"1","ShareYourPost":"10","WhoRevealsPostThisPost": "Public","LikeLimit":selectedLikeLimitCount!,"ShareLimit":"10","DonationLimit":"2147","UserId":userID] as [String : Any]
                
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
            
      
      /*  let postReviewVC = PostReviewVC(nibName: "PostReviewVC", bundle: nil)
        _ = postReviewVC.view
        postReviewVC.titleTxtLabel.text = self.titleLabelText
        postReviewVC.descTxtLabel.text = self.descriptionTextView
        postReviewVC.locationTxtLabel.text = self.locationText
        self.navigationController?.pushViewController(postReviewVC, animated: true)
      */
}
func uploadBlurredImageToServer(postID : String)
{
    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("1.jpg"))
    
    let image    = UIImage(contentsOfFile: imgPath.path)
    
    let resizedImage = image?.resizeImage(image: image!, newWidth: (image?.size.width)!*0.5)!
    
    let parameters : [String: String] = ["Mediatype":"1","postID":postID]
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(UIImageJPEGRepresentation(resizedImage!, 0.5)!, withName: "UploadPhoto", fileName: "UploadImage.jpeg", mimeType: "image/jpeg")
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
}
// MARK: Tableview Datasource and Delegate
extension CreateNewPostVC : UITableViewDataSource, UITableViewDelegate
{
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 || indexPath.section == 1
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 50.0)
        }
        else if indexPath.section == 2 || indexPath.section == 3
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 70.0)
        }
        else
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 324.0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        switch indexPath.section
        {
            
        case 0:
            let cell : TitleCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TitleCellIdentifier.rawValue, for: indexPath) as! TitleCell
            cell.titleTF.delegate = self
            return cell
            
        case 1:
            let cell : LocationCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LocationCellIdentifier.rawValue, for: indexPath) as! LocationCell
            cell.locationTF.delegate = self
            return cell
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.DescriptionCellIdentifier.rawValue, for: indexPath) as! DescriptionCell
            cell.descriptionTV.delegate = self
            cell.descriptionDelegate = self
            return cell
        case 3:
            let cell : ShareYourPost = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ShareYourPostCellIdentifier.rawValue, for: indexPath) as! ShareYourPost
            cell.shareYourPostDelegate = self
            return cell
        case 4:
            let cell : BlurImageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.BlurImageCellIdentifier.rawValue, for: indexPath) as! BlurImageCell
            let likesStr = "\(selectedLikeLimitCount!) - Likes"
            cell.likesToReveal.text = likesStr
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
}
extension CreateNewPostVC : UITextFieldDelegate
{
    // MARK: Textfield Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    /*func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.placeholder == "Title"
        {
            textField.placeholder = ""
        }
        else
        {
            textField.placeholder = ""
        }
        
    }*/
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if textField.placeholder == "Title"
        {
            self.titleLabelText = textField.text
        }
        else
        {
            self.locationText = textField.text
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
       /*if textField.text?.count == 0
       {
        
       }*/
       let maxLength = 30
       let currentString: NSString = textField.text! as NSString
       let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
       return newString.length <= maxLength
        
    }
    
}
extension CreateNewPostVC : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        self.descriptionTextView = textView.text
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
       cell.placeholderLabel.isHidden = !cell.descriptionTV.text.isEmpty
    }
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        let maxLength = 120
        let currentString: NSString = textView.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength

    }
}
extension CreateNewPostVC : ShareYourPostDelegate
{
    /*func pbPublicOrPrivateDidTap(privateOrPublicButton:UIButton)
    {
        // SET BUTTON TAG 201 MEANS PUBLIC IN XIB
        if privateOrPublicButton.tag == 201
        {
          self.whoGetsToReveal = "Public"
        }
        else
        {
            self.whoGetsToReveal = "Private"
        }
    }*/
    func pbTwitterBtnDidTap()
    {
      self.postTosocialNetwork = "Twitter"
    }
    func pbFaceBookBtnDidTap()
    {
        self.postTosocialNetwork = "Facebook"

    }
    /*func pbDonateBtnDidTap(selectedDonatedButton : UIButton)
    {
        switch selectedDonatedButton.tag
        {
            case 101:
            self.donateToCharity = "United Way"
                break
            case 102:
                self.donateToCharity = "American cancer society"
                break
            case 103:
                self.donateToCharity = "American red cross"
                break
            case 104:
                self.donateToCharity = "American heart association"
                break
        default:
            self.donateToCharity = "Boys and girls club of america"
            break

        }
    }*/
}

extension CreateNewPostVC : PBDescriptionCellDelegate
{
    func doneButtonDidTapOnDescriptionView(_ textView: UITextView)
    {
        textView.resignFirstResponder()
        if textView.text != nil
        {
        self.descriptionTextView = textView.text
        }

    }
}
