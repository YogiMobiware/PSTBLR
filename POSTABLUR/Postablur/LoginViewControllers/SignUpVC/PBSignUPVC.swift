//
//  PBSignUPVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/18/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
import Alamofire


class PBSignUPVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    @IBOutlet weak var signUpTableView: UITableView!
    var imageWidth : CGFloat!
    var imageHeight : CGFloat!
    var appdelegate : AppDelegate!
    var uploadImageType : String?
    var imageCell : AddProfilePhotoCell!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headerNib = UINib(nibName: NibNamed.PBHeaderCell.rawValue, bundle: nil)
        self.signUpTableView.register(headerNib, forCellReuseIdentifier: CellIdentifiers.PBHeaderCellIdentifier.rawValue)
        
        let addProfileNib = UINib(nibName: NibNamed.AddProfilePhotoCell.rawValue, bundle: nil)
        self.signUpTableView.register(addProfileNib, forCellReuseIdentifier: CellIdentifiers.AddProfilePhotoCellIdentifier.rawValue)
        
        let registrationNib = UINib(nibName: NibNamed.RegistrationCell.rawValue, bundle: nil)
        self.signUpTableView.register(registrationNib, forCellReuseIdentifier: CellIdentifiers.RegistrationCellIdentifier.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PBSignUPVC.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PBSignUPVC.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PBSignUPVC.tapGestureRecognized))
        self.signUpTableView.addGestureRecognizer(tapRecogniser)

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let _ = UserDefaults.standard.object(forKey: Constants.kUserProfilePicURL)
        {
            UserDefaults.standard.removeObject(forKey: Constants.kUserProfilePicURL)
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc internal func tapGestureRecognized()
    {
        UIView.animate(withDuration: 0.2, animations: {
           
            self.signUpTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    
    @objc internal func keyboardWasShown(aNotification: NSNotification)
    {
        UIView.animate(withDuration: 0.2, animations: {

        if let keyboardHeight = (aNotification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.signUpTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            }
        })

    }
    
    @objc internal func keyboardWillBeHidden(aNotification: NSNotification)
    {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.signUpTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Image picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if let  chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let resizedImage = chosenImage.resizeImage(image: chosenImage, newWidth: 70)!
            self.uploadUserProfileImageToServer(selectedImage: resizedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadUserProfileImageToServer(selectedImage : UIImage)
    {
    let parameters : [String: String] = ["Mediatype"  : "1"]
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(UIImageJPEGRepresentation(selectedImage, 0.5)!, withName: "photo_path", fileName: "PostaBlur.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:Urls.uploadImageUrl)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    self.appdelegate.showActivityIndictor(titleString: "Uploading...", subTitleString: "")

                })
                
                upload.responseJSON { response in
                    self.appdelegate.hideActivityIndicator()
                    self.imageCell.selectedImageViewType(image: selectedImage, imageType: self.uploadImageType!)
                    
                    if let JSON = response.result.value
                    {
                        print("JSON: \(JSON)")
                        if let responseDict = JSON as? [String : AnyObject]
                        {
                            if let returnUrl = responseDict["RetrurnUrl"] as! String!
                            {
                                UserDefaults.standard.setValue(returnUrl, forKey: Constants.kUserProfilePicURL)
                                UserDefaults.standard.synchronize()
                            }
                        }
                        else
                        {
                            let responseDict = JSON as? [String : AnyObject]
                            self.appdelegate.alert(vc: self, message: responseDict!["StatusMsg"] as! String!, title: "Error Uploading")

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
}

extension PBSignUPVC : UITextFieldDelegate
{
    
    // MARK: Textfield Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: Tableview Datasource and Delegate
extension PBSignUPVC : UITableViewDataSource, UITableViewDelegate
{
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 113.0)
        }
        else if indexPath.section == 1
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 178.0)
        }
        else
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 350.0)
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
            let cell : PBHeaderCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PBHeaderCellIdentifier.rawValue, for: indexPath) as! PBHeaderCell
            cell.delegate = self
            return cell
            
        case 1:
            let cell : AddProfilePhotoCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AddProfilePhotoCellIdentifier.rawValue, for: indexPath) as! AddProfilePhotoCell
            //Taking reference to pass parameter to Cell Class
            imageCell = cell
            cell.delegate = self
            return cell
            
        case 2:
            let cell : RegistrationCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.RegistrationCellIdentifier.rawValue, for: indexPath) as! RegistrationCell
            cell.registerDelegate = self
            cell.userNameTF.delegate = self
            cell.emailTF.delegate = self
            cell.passwordTF.delegate = self
            cell.reTypePasswordTF.delegate = self
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
   
}

// MARK: --  HEADER DELEGATES
extension PBSignUPVC : PBHeaderCellDelegate
{
    func pbBackBtnDidTap()
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
}

// MARK: --  ADDPROFILE DELEGATES
extension PBSignUPVC : AddProfilePhotoCellDelegate
{
    func pbCaptureAPhotoImageDidTap(capturedPhotoWidth: CGFloat,capturedPhotoHeight: CGFloat)
    {
        self.uploadImageType = UploadedImageType.CapturedPhotoFromCamera.rawValue
        self.imageWidth = capturedPhotoWidth
        self.imageHeight = capturedPhotoHeight
        let pbImagePickerController = UIImagePickerController()
        pbImagePickerController.delegate = self
        pbImagePickerController.allowsEditing = true
        pbImagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        present(pbImagePickerController, animated: true, completion: nil)
    }
    
    func pbUploadAPhotoImageDidTap(uploadPhotoWidth: CGFloat, uploadPhotoHeight: CGFloat)
    {
        self.uploadImageType = UploadedImageType.UploadedPhotoFromLibrary.rawValue
        self.imageWidth = uploadPhotoWidth
        self.imageHeight = uploadPhotoHeight
        let pbImagePickerController = UIImagePickerController()
        pbImagePickerController.delegate = self
        pbImagePickerController.allowsEditing = true
        pbImagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(pbImagePickerController, animated: true, completion: nil)
        
    }
}


// MARK: -- REGISTRATION DELEGATES
extension PBSignUPVC : RegistrationCellDelegate
{
    func pbnextBtnDidTap(userNameTF: UITextField, emailTF: UITextField, passwordTF: UITextField, reTypePasswordTF: UITextField)
    {
        if (userNameTF.text?.isEmpty)! && (emailTF.text?.isEmpty)! && (passwordTF.text?.isEmpty)! && (reTypePasswordTF.text?.isEmpty)!
        {
             self.appdelegate.alert(vc: self, message: "Enter all fields", title: "SignUp")
             return
        }
        
        if (userNameTF.text?.isEmpty)!
        {
            self.appdelegate.alert(vc: self, message: "Enter username", title: "SignUp")
            return
        }
        
        if (emailTF.text?.isEmpty)!
        {
            self.appdelegate.alert(vc: self, message: "Enter email", title: "SignUp")
            return
        }
        
        if !ValidationHelper.isValidEmail(emailStr: (emailTF.text)!)
        {
            self.appdelegate.alert(vc: self, message: "Enter valid email", title: "SignUp")
            return
        }
        
        if (passwordTF.text?.isEmpty)!
        {
            self.appdelegate.alert(vc: self, message: "Enter password", title: "SignUp")
            return
        }
            
        if (reTypePasswordTF.text?.isEmpty)!
        {
            self.appdelegate.alert(vc: self, message: "Enter retype password", title: "SignUp")
            return
        }
            
        if (passwordTF.text?.count)! < 6
        {
            self.appdelegate.alert(vc: self, message: "Password minimum 6 digits", title: "SignUp")
            return
        }
        
        if (passwordTF.text) != (reTypePasswordTF.text)
        {
            self.appdelegate.alert(vc: self, message: "Both passwords must same", title: "SignUp")
            return
        }
        
        var uploadedprofileStr : String!
        
        if let userProfilelStr = UserDefaults.standard.object(forKey: Constants.kUserProfilePicURL) as? String
        {
           uploadedprofileStr = userProfilelStr
        }
        else
        {
            uploadedprofileStr = ""
        }
        
        let urlString = String(format: "%@/UserRegistration", arguments: [Urls.mainUrl]);
        let requestDict = ["UserName":userNameTF.text!,"Email":emailTF.text!,"Password":passwordTF.text!,"DOB":"","DBAPin":"","Profileurl":uploadedprofileStr,
            "ProfileAd":"","Accounttype":"1","PhoneNumber":"","CountryCode":"+91","Registrationtype":"1",
            "DeviceId":"123456","DeviceType":"1"] as [String : Any]
        
        self.appdelegate.showActivityIndictor(titleString: "SignUp", subTitleString: "")
        
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
                            print("signup result \(result)")
                            
                            let statusCode = result["StatusCode"] as! String
                            let statusMessage = result["StatusMsg"] as! String
                            
                            if statusCode == "0"
                            {
                                    self.getUserProfileDetails(userID: result["UserId"] as! String)
                            
                            }
                            else
                            {
                                self.appdelegate.hideActivityIndicator()
                                self.appdelegate.alert(vc: self, message: statusMessage, title: "SignUp")

                                return
                            }
                            
                        }
                    }
                    if let responseStr = responseObject as? String
                    {
                        self.appdelegate.hideActivityIndicator()
                        self.appdelegate.alert(vc: self, message: responseStr, title: "SignUp")

                        return
                    }
                    
                }
                else
                {
                    self.appdelegate.hideActivityIndicator()
                    self.appdelegate.alert(vc: self, message: "Something went wrong", title: "SignUp")

                    return
                }
            }
            else
            {
                self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "SignUp")
                return
            }
           
        }
    }
    
    func getUserProfileDetails(userID : String)
    {
        
        let urlString = String(format: "%@/GetProfileDetails/%@", arguments: [Urls.mainUrl,userID]);

        PBServiceHelper().get(url: urlString) { (responseObject : AnyObject?, error : Error?) in
            
            if error == nil
            {
                if responseObject != nil
                {
                    self.appdelegate.hideActivityIndicator()

                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        if let resultArray = responseDict["GetProfileDetailsResult"]!["Results"] as! [NSDictionary]!
                        {
                            let result = resultArray.first!
                            print("signup result \(result)")
                            
                            let statusCode = result["StatusCode"] as! String
                            let statusMessage = result["StatusMsg"] as! String

                            if statusCode == "0"
                            {
                                
                                if let userId = result["UserId"] as? String
                                {
                                    UserDefaults.standard.removeObject(forKey: "UserId")
                                    UserDefaults.standard.set(userId, forKey: "UserId")
                                }
                                if let email = result["Email"] as? String
                                {
                                    UserDefaults.standard.removeObject(forKey: "Email")
                                    UserDefaults.standard.set(email, forKey: "Email")
                                }
                                if let profileUrl = result["Profileurl"] as? String
                                {
                                    UserDefaults.standard.removeObject(forKey: Constants.kUserProfilePicURL)
                                    UserDefaults.standard.set(profileUrl, forKey: Constants.kUserProfilePicURL)
                                }
                                if let username = result["UserName"] as? String
                                {
                                    UserDefaults.standard.removeObject(forKey: "UserName")
                                    UserDefaults.standard.set(username, forKey: "UserName")
                                }
                                
                                UserDefaults.standard.synchronize()
                                
                                let pbAccountTypeVC = PBAccountTypeVC()
                                self.navigationController?.pushViewController(pbAccountTypeVC, animated: true)
                                return
                            }
                            else
                            {

                                self.appdelegate.alert(vc: self, message: statusMessage, title: "SignUp")
                                return
                            }
                            
                        }
                    }
                    if let responseStr = responseObject as? String
                    {

                        self.appdelegate.alert(vc: self, message: responseStr, title: "SignUp")
                        return
                    }
                    
                }
                else
                {
                    self.appdelegate.alert(vc: self, message: "Something went wrong", title: "SignUp")
                    return
                }
            }
            else
            {
                self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "SignUp")
                return
            }
        }
        
    }
    func pbloginBtnDidTap()
    {
        _ = self.navigationController?.popViewController(animated: true)

    }
}


