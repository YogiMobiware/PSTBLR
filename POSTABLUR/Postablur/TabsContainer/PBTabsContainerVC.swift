//
//  PBTabsContainerVC.swift
//  Postablur
//
//  Created by Yogi on 22/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

class PBTabsContainerVC: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet weak var childContentView: UIView!
    var homeNavigationController : UINavigationController? = nil;
    
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    
    @IBOutlet weak var feedButtonLbl: UILabel!
    @IBOutlet weak var newPostButtonLbl: UILabel!
    @IBOutlet weak var statsButtonLbl: UILabel!
    @IBOutlet weak var profileButtonLbl: UILabel!
    
    
    var selectedButton : UIButton!
    
    var style = ToastStyle()
    
    // MARK: -  Activity Indicator
    var faProgressHud : MBProgressHUD!
    
    // MARK: Inits
    init()
    {
        super.init(nibName: NibNamed.PBTabsContainerVC.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.style.messageColor = .white
        
        
        if let userProfileUrlStr = UserDefaults.standard.object(forKey: Constants.kUserProfilePicURL) as? String
        {
            if let userProfileUrl = URL(string: userProfileUrlStr)
            {
                self.profileButton.kf.setImage(with: userProfileUrl, for: .normal)
            }
            else
            {
                if let image = UIImage(named: "default_avatar")
                {
                    self.profileButton.setImage(image, for: .normal)
                }

            }
        }
        
        
        if let image = feedButton.imageView?.image
        {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            feedButton.setImage(templateImage, for: .normal)
        }
        
        if let image = newPostButton.imageView?.image
        {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            newPostButton.setImage(templateImage, for: .normal)
        }
        
        if let image = statsButton.imageView?.image
        {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            statsButton.setImage(templateImage, for: .normal)
        }

        
        
        let feedVC = PBFeedsVC()
        self.homeNavigationController = UINavigationController(rootViewController: feedVC)
        self.homeNavigationController?.isNavigationBarHidden = true
        self.homeNavigationController!.delegate = self
        feedVC.tabContainerVC = self

        self.presentHomeNavigationController();

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func presentHomeNavigationController()
    {
        
        self.childContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        let childView = homeNavigationController!.view
        childView?.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(homeNavigationController!)
        homeNavigationController!.didMove(toParentViewController: self)
        self.childContentView.addSubview(childView!)
        self.childContentView.clipsToBounds = true;
        
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        
        self.view.setNeedsLayout()
        
        self.view.layoutIfNeeded()
        
        
    }

    
    func enableButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.isUserInteractionEnabled = true
            }
        }
        else
        {
            feedButton.isUserInteractionEnabled = true
            newPostButton.isUserInteractionEnabled = true
            statsButton.isUserInteractionEnabled = true
            qrButton.isUserInteractionEnabled = true
            profileButton.isUserInteractionEnabled = true
        }
    }
    
    
    
    func disableButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.isUserInteractionEnabled = false
            }
        }
        else
        {
            feedButton.isUserInteractionEnabled = false
            newPostButton.isUserInteractionEnabled = false
            statsButton.isUserInteractionEnabled = false
            qrButton.isUserInteractionEnabled = false
            profileButton.isUserInteractionEnabled = false
        }
        
    }
    
    func selectButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.tintColor = Constants.navBarTintColor
            }
        }
        else
        {
            feedButton.tintColor = Constants.navBarTintColor
            newPostButton.tintColor = Constants.navBarTintColor
            statsButton.tintColor = Constants.navBarTintColor
            profileButton.tintColor = Constants.navBarTintColor
        }
    }
    
    func unselectButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.tintColor = Constants.greyTintColor
            }
        }
        else
        {
            feedButton.tintColor = Constants.greyTintColor
            newPostButton.tintColor = Constants.greyTintColor
            statsButton.tintColor = Constants.greyTintColor
            profileButton.tintColor = Constants.greyTintColor
        }
        
    }

    func selectButtonLbls(_ menuButtonLbls : [UILabel]?)
    {
        if let labels = menuButtonLbls
        {
            for label in labels
            {
                label.textColor = Constants.navBarTintColor
            }
        }
        else
        {
            feedButtonLbl.textColor = Constants.navBarTintColor
            newPostButtonLbl.textColor = Constants.navBarTintColor
            statsButtonLbl.textColor = Constants.navBarTintColor
            profileButtonLbl.textColor = Constants.navBarTintColor
        }
    }
    
    func unselectButtonLbls(_ menuButtonLbls : [UILabel]?)
    {
        if let labels = menuButtonLbls
        {
            for label in labels
            {
                label.textColor = Constants.greyTintColor
            }
        }
        else
        {
            feedButtonLbl.textColor = Constants.greyTintColor
            newPostButtonLbl.textColor = Constants.greyTintColor
            statsButtonLbl.textColor = Constants.greyTintColor
            profileButtonLbl.textColor = Constants.greyTintColor
        }
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func feedTapped(_ sender : UIButton)
    {
        guard self.selectedButton != self.feedButton else
        {
            return
        }
        self.disableButtons(nil)
        let feedVC = PBFeedsVC()
        feedVC.tabContainerVC = self
        self.homeNavigationController?.pushViewController(feedVC, animated: false)

    }
    
    @IBAction func createPostTapped(_ sender : UIButton)
    {
        guard self.selectedButton != self.newPostButton else
        {
            return
        }
        let newPostVC = PBCaptureMediaVC()
        newPostVC.delegate = self
        let newPostNavController = UINavigationController(rootViewController: newPostVC)
        newPostNavController.isNavigationBarHidden = true
        self.homeNavigationController?.present(newPostNavController, animated: true, completion: {
            
        })
    }
    
    @IBAction func qrTapped(_ sender : UIButton)
    {

        guard self.selectedButton != self.qrButton else
        {
            return
        }
        self.disableButtons(nil)
        let qrVC = QRCodeScannerVC()
        qrVC.tabContainerVC = self
        self.homeNavigationController?.pushViewController(qrVC, animated: false)

    }
    
    @IBAction func statsTapped(_ sender : UIButton)
    {
        
        /*let alertView = UIAlertController(title: "Postablur", message: "Stats coming soon...", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)*/
        
        self.view.makeToast("Stats coming soon...", duration: 3.0, position: .center, style: style)
        
        
    }
    
    @IBAction func profileTapped(_ sender : UIButton)
    {
        guard self.selectedButton != self.profileButton else
        {
            return
        }
        self.disableButtons(nil)
        let accountsVC = AccountsVC()
        accountsVC.tabContainerVC = self
        self.homeNavigationController?.pushViewController(accountsVC, animated: false)
        
    }
    
    // MARK : - UINavigationController Delegate
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.hideActivityIndicator()
        
        
        self.enableButtons(nil)
        self.unselectButtons(nil)
        self.unselectButtonLbls(nil)
        if viewController.isKind(of: PBFeedsVC.self)
        {
            self.disableButtons([self.feedButton])
            self.selectedButton = self.feedButton
            
            self.selectButtons([self.feedButton])
            self.selectButtonLbls([self.feedButtonLbl])
        }
        else if viewController.isKind(of: PBCaptureMediaVC.self)
        {
            self.disableButtons([self.newPostButton])
            self.selectedButton = self.newPostButton
            
            self.selectButtons([self.newPostButton])
            self.selectButtonLbls([self.newPostButtonLbl])

        }
        else if viewController.isKind(of: QRCodeScannerVC.self)
        {
            self.disableButtons([self.qrButton])
            self.selectedButton = self.qrButton
        }
        else if viewController.isKind(of: AccountsVC.self)
        {
            self.disableButtons([self.profileButton])
            self.selectedButton = self.profileButton
            
            self.selectButtonLbls([self.profileButtonLbl])

        }
        else if viewController.isKind(of: PBFeedsVC.self)
        {
            self.disableButtons([self.feedButton])
            self.selectedButton = self.feedButton
            
            self.selectButtons([self.feedButton])
            self.selectButtonLbls([self.feedButtonLbl])

        }
    }
    

    

    //MARK:- Locking orientation to Portrait only
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        
        return UIInterfaceOrientation.portrait
    }

}

//MARK:- PBCaptureMediaVC Delegate
extension PBTabsContainerVC : PBCaptureMediaVCDelegate
{
    func pbCaptureMediaVCDidTapDismiss(captureVC: PBCaptureMediaVC) {
        
        self.dismiss(animated: true) {
            
        }
    }

}


