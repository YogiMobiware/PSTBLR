//
//  PBLoginOptionsVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/18/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class PBLoginOptionsVC: UIViewController
{

    @IBOutlet weak var loginTableView: UITableView!
    
    var appdelegate : AppDelegate!
    
    var socialEmail : String!
    var socialRegistrationType : String!
    var socialProvider : String!
    var socialAccessToken : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let logoNib = UINib(nibName: NibNamed.PBLogoCell.rawValue, bundle: nil)
        self.loginTableView.register(logoNib, forCellReuseIdentifier: CellIdentifiers.LogoHeaderReuseIdentifier.rawValue)
        
        let emailNib = UINib(nibName: NibNamed.PBEmailAndPasswrdCell.rawValue, bundle: nil)
        self.loginTableView.register(emailNib, forCellReuseIdentifier: CellIdentifiers.EmailAndPasswrdReuseIdentifier.rawValue)
        
        let socialNib = UINib(nibName: NibNamed.PBSocialLoginCell.rawValue, bundle: nil)
        self.loginTableView.register(socialNib, forCellReuseIdentifier: CellIdentifiers.SocialReuseIdentifier.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PBLoginOptionsVC.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PBLoginOptionsVC.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let tapRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PBLoginOptionsVC.tapGestureRecognized))
        self.loginTableView.addGestureRecognizer(tapRecogniser)

    }
    
    @objc internal func tapGestureRecognized()
    {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.loginTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    @objc internal func keyboardWasShown(aNotification: NSNotification)
    {
        UIView.animate(withDuration: 0.2, animations: {
            
            if let keyboardHeight = (aNotification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            {
                self.loginTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            }
        })
        
    }
    
    @objc internal func keyboardWillBeHidden(aNotification: NSNotification)
    {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.loginTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler:
                { (connection, result, error) -> Void in
                    if (error == nil)
                    {
                        //everything works print the user data
                        print("result: \(String(describing: result))")
                        
                        let dict = result as! NSDictionary
                        let email = dict["email"] as! String
                        let name = dict["name"] as! String
                        let fbId = dict["id"] as! String
                        
                        self.socialEmail = email
                        self.socialRegistrationType = "3"
                        self.socialProvider = "Facebook"
                        self.socialAccessToken = FBSDKAccessToken.current().tokenString
                        
                        
                        let profileImageUrl = "https://graph.facebook.com/\(fbId)/picture";
                        
                        let urlString = String(format: "%@/UserRegistration", arguments: [Urls.mainUrl]);
                        let requestDict = ["UserName": name,"Email": email,"Password": "","DOB":"","DBAPin":"","Profileurl": profileImageUrl,"ProfileAd":"","Accounttype":"1","PhoneNumber":"","CountryCode":"+91","Registrationtype":"3","DeviceId":"123456","DeviceType":"1"] as [String : Any]
                        
                        self.appdelegate.showActivityIndictor(titleString: "Facebook SignIn", subTitleString: "")
                        
                        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
                            
                            self.appdelegate.hideActivityIndicator()
                            if error == nil
                            {
                                if responseObject != nil
                                {
                                    if let responseDict = responseObject as? [String : AnyObject]
                                    {
                                        if let resultArray = responseDict["Results"] as! [NSDictionary]!
                                        {
                                            let result = resultArray.first!
                                            
                                            print("FB Details \(result)")
                                            
                                            let statusCode = result["StatusCode"] as! String
                                            let statusMessage = result["StatusMsg"] as! String
                                            
                                            if statusCode == "0"
                                            {
                                                let qrCodeScannerVC = QRCodeScannerVC()
                                                self.navigationController?.pushViewController(qrCodeScannerVC, animated: true)

                                                return
                                            }
                                            else if statusCode == "1"
                                            {
                                                self.appdelegate.alert(vc: self, message: statusMessage, title: "Error")
                                                return
                                            }
                                            else if statusCode == "2"
                                            {
                                                self.appdelegate.alert(vc: self, message: statusMessage, title: "Error")
                                                return
                                            }
                                            else if statusCode == "3"
                                            {
                                                self.alreadyRegistrationCall()
                                                return
                                            }
                                        }
                                    }
                                    if let responseStr = responseObject as? String
                                    {
                                        self.appdelegate.alert(vc: self, message: responseStr, title: "Error")
                                        return
                                    }
                                    
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
            })
        }
    }
    
    
    func getTwitterUserData(username: String, email: String, access_token: String)
    {
        self.socialEmail = email
        self.socialRegistrationType = "2"
        self.socialProvider = "Twitter"
        self.socialAccessToken = access_token 
        
        let urlString = String(format: "%@/UserRegistration", arguments: [Urls.mainUrl]);
        
        let requestDict = ["UserName": username,"Email": email,"Password": "","DOB":"","DBAPin":"","Profileurl": "","ProfileAd":"","Accounttype":"1","PhoneNumber":"","CountryCode":"+91","Registrationtype":"2","DeviceId":"123456","DeviceType":"1"] as [String : Any]
        
        self.appdelegate.showActivityIndictor(titleString: "Twitter SignIn", subTitleString: "")
        
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            self.appdelegate.hideActivityIndicator()
            if error == nil
            {
                if responseObject != nil
                {
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        if let resultArray = responseDict["Results"] as! [NSDictionary]!
                        {
                            let result = resultArray.first!
                            
                            print("Twitter Details \(result)")
                            
                            let statusCode = result["StatusCode"] as! String
                            let statusMessage = result["StatusMsg"] as! String
                            
                            if statusCode == "0"
                            {
                                let qrCodeScannerVC = QRCodeScannerVC()
                                self.navigationController?.pushViewController(qrCodeScannerVC, animated: true)

                                return
                            }
                            else if statusCode == "1"
                            {
                                self.appdelegate.alert(vc: self, message: statusMessage, title: "Error")
                                return
                            }
                            else if statusCode == "2"
                            {
                                self.alreadyRegistrationCall()
                        
                                return
                            }
                            else if statusCode == "3"
                            {
                                self.appdelegate.alert(vc: self, message: statusMessage, title: "Error")
                                return
                            }
                        }
                    }
                    if let responseStr = responseObject as? String
                    {
                        self.appdelegate.alert(vc: self, message: responseStr, title: "Error")
                        return
                    }
                    
                }
                else
                {
                    self.appdelegate.alert(vc: self, message: "Something went wrong", title: "Error")
                    return
                }
            }
            else
            {
                self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: " SignIn")
                return
            }
        }
    }
    
    func alreadyRegistrationCall()
    {
        let urlString = String(format: "%@/Externalloginprofiledetails", arguments: [Urls.mainUrl]);
        let requestDict = ["Email": self.socialEmail,"Registrationtype": self.socialRegistrationType,"Provider": self.socialProvider,"ExternalAccessToken": self.socialAccessToken] as [String : Any]
        
        if self.socialRegistrationType == "2"
        {
            self.appdelegate.showActivityIndictor(titleString: "Twitter SignIn", subTitleString: "")
        }
        else if self.socialRegistrationType == "3"
        {
            self.appdelegate.showActivityIndictor(titleString: "Facebook SignIn", subTitleString: "")
        }
        
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            self.appdelegate.hideActivityIndicator()
            
            if error == nil
            {
                if responseObject != nil
                {
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        if let resultArray = responseDict["Results"] as! [NSDictionary]!
                        {
                            let result = resultArray.first!
                            
                            print("External Login Details \(result)")
                            
                            let statusCode = result["StatusCode"] as! String
                            let statusMessage = result["StatusMsg"] as! String
                            
                            if statusCode == "0"
                            {
                                let qrCodeScannerVC = QRCodeScannerVC()
                                self.navigationController?.pushViewController(qrCodeScannerVC, animated: true)
                                
                                return
                            }
                            else
                            {
                                if self.socialRegistrationType == "2"
                                {
                                    self.appdelegate.alert(vc: self, message: statusMessage, title: "Twitter SignIn")
                                }
                                else if self.socialRegistrationType == "3"
                                {
                                    self.appdelegate.alert(vc: self, message: statusMessage, title: "Facebook SignIn")
                                }
                                return
                            }
                            
                        }
                    }
                }
                else
                {
                    if self.socialRegistrationType == "2"
                    {
                        self.appdelegate.alert(vc: self, message: "Something went wrong", title: "Twitter SignIn")
                    }
                    else if self.socialRegistrationType == "3"
                    {
                        self.appdelegate.alert(vc: self, message: "Something went wrong", title: "Facebook SignIn")
                    }
                    return
                }
            }
            else
            {
                if self.socialRegistrationType == "2"
                {
                    self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Twitter SignIn")
                }
                else if self.socialRegistrationType == "3"
                {
                    self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Facebook SignIn")
                }
                return
            }
        }
    }
}

extension PBLoginOptionsVC : UITextFieldDelegate
{
    
    // MARK: Textfield Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: Tableview Datasource and Delegate
extension PBLoginOptionsVC : UITableViewDataSource, UITableViewDelegate
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
            return Constants.calculateDynamicTableviewCellHeight(cellHeight: 262.0)

        }
        else if indexPath.section == 1
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 145.0)
        }
        else
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 150.0)
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
            let cell : PBLogoCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LogoHeaderReuseIdentifier.rawValue, for: indexPath) as! PBLogoCell
            return cell
            
        case 1:
            let cell : PBEmailAndPasswrdCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.EmailAndPasswrdReuseIdentifier.rawValue, for: indexPath) as! PBEmailAndPasswrdCell
            cell.emailDelegate = self
            cell.emailTextField.delegate = self
            cell.passwordTextField.delegate = self
            return cell
            
        case 2:
            let cell : PBSocialLoginCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SocialReuseIdentifier.rawValue, for: indexPath) as! PBSocialLoginCell
            cell.socialLoginDelegate = self
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
   
}
// MARK: --  EMAIL AND PASSWORD DELEGATES
extension PBLoginOptionsVC : PBEmailAndPasswrdCellDelegate
{
    func pbLoginBtnDidTap(emailTextField: UITextField, passwordTextField: UITextField)
    {
        if (emailTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)!
        {
            self.appdelegate.alert(vc: self, message: "Enter email and password", title: "SignIn")
            return
        }
        if (emailTextField.text?.isEmpty)!
        {
            self.appdelegate.alert(vc: self, message: "Enter email", title: "SignIn")
            return
        }
        if !ValidationHelper.isValidEmail(emailStr: emailTextField.text!)
        {
            self.appdelegate.alert(vc: self, message: "Enter valid email", title: "SignIn")
            return
        }
        if (passwordTextField.text?.isEmpty)!
        {
            self.appdelegate.alert(vc: self, message: "Enter password", title: "SignIn")
            return
        }
        
        let urlString = String(format: "%@/LoginVerify", arguments: [Urls.mainUrl]);
        let requestDict = ["Username":emailTextField.text,"Password":passwordTextField.text]
        
        self.appdelegate.showActivityIndictor(titleString: "SignIn", subTitleString: "")
        
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            self.appdelegate.hideActivityIndicator()
            
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
                            let statusMessage = result["StatusMsg"] as! String
                            
                            if statusCode == "0"
                            {
                                
                                let qrCodeScannerVC = QRCodeScannerVC()
                                self.navigationController?.pushViewController(qrCodeScannerVC, animated: true)

                                //self.appdelegate.alert(vc: self, message: statusMessage, title: "SignIn")
                                return
                            }
                            else
                            {
                                self.appdelegate.alert(vc: self, message: statusMessage, title: "Error")
                                return
                            }
                            
                        }
                    }
                    if let responseStr = responseObject as? String
                    {
                        self.appdelegate.alert(vc: self, message: responseStr, title: "Error")
                        return
                    }

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
  
    func pbForgetPasswordDidTap()
    {
        
    }
    
}

// MARK: --  SOCIAL LOGIN DELEGATES
extension PBLoginOptionsVC : PBSocialLoginCellDelegate
{
    func pbCreateBtnDidTap()
    {
        let signUpVC = PBSignUPVC()
        self.navigationController?.pushViewController(signUpVC, animated: true);
        
    }
    func pbTwitterBtnDidTap()
    {
        self.appdelegate.registrationType = 2
        if appdelegate.isNetworkReachable() == true
        {
            TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
              if (session != nil)
              {
                let username = session?.userName
                
                let access_token = session?.authToken
                
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail { email, error in
                    
                    if (email != nil)
                    {
                        self.getTwitterUserData(username: username!, email: email!, access_token: access_token!)
                    }
                    else
                    {
                        self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Error")
                        //print(error!)
                    }
                }
                
              }
              else
              {
                self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Error")
                //print("error: \(String(describing: error?.localizedDescription))");
              }
           })
        }
        else
        {
            self.appdelegate.alert(vc: self, message: "Unable to complete network request.  No Internet connection present.", title: "Error")
        }
    }
    
    
    func pbfaceBookBtnDidTap()
    {
        self.appdelegate.registrationType = 3
        
        if appdelegate.isNetworkReachable() == true
        {
            if (FBSDKAccessToken.current() != nil)
            {
                // User is already logged in, do work such as go to next view controller.
                print("already logged in ")
                self.getFBUserData()
                
                return
            }
            
            let faceBookLoginManger = FBSDKLoginManager()
            faceBookLoginManger.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self)
            { (result, error) in
                
                if let fbloginresult : FBSDKLoginManagerLoginResult = result
                {
                    if fbloginresult.isCancelled
                    {
                        print("cancelled")
                        return
                    }
                    
                    if (fbloginresult.grantedPermissions.contains("email")) && (fbloginresult.grantedPermissions != nil)
                    {
                        self.getFBUserData()
                    }
                    else
                    {
                        if let error = error
                        {
                            self.appdelegate.alert(vc: self, message: error.localizedDescription, title: "Error")
                            //print("error is \(String(describing: error))")
                        }
                        
                    }
                }
            }

        }
        else
        {
            self.appdelegate.alert(vc: self, message: "Unable to complete network request.  No Internet connection present.", title: "Error")
        }
    }
    
}

