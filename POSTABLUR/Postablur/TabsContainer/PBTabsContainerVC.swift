//
//  PBTabsContainerVC.swift
//  Postablur
//
//  Created by Yogi on 22/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import Foundation
import UIKit

class PBTabsContainerVC: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet weak var childContentView: UIView!
    var homeNavigationController : UINavigationController? = nil;
    
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var selectedButton : UIButton!
    
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
        
        ////////////////
        
        self.disableButtons([self.feedButton])
        self.selectedButton = self.feedButton
        
        ////////////////
        
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
    

//    func setProgressHudHidden(_ hidden : Bool)
//    {
//
//        if hidden == false
//        {
//            let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
//            self.faProgressHud = storyBoard.instantiateViewController(withIdentifier: "FAProgressHud") as? FAProgressHud
//
//            let childView = self.faProgressHud!.view
//            childView?.translatesAutoresizingMaskIntoConstraints = false;
//
//            self.addChildViewController(faProgressHud)
//            faProgressHud!.didMove(toParentViewController: self)
//            self.view.addSubview(childView!)
//            self.view.clipsToBounds = true
//
//            let xConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
//
//            let yConstraint =  NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
//
//            let tConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
//
//            let bConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
//
//            self.view.addConstraints([xConstraint, yConstraint, tConstraint, bConstraint])
//
//            self.faProgressHud.view.layoutIfNeeded()
//
//        }
//        else
//        {
//            //hide
//            self.faProgressHud.view.removeFromSuperview()
//        }
//    }
    
    
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
        
        let alertView = UIAlertController(title: "Postablur", message: "Stats coming soon...", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
        
        
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
        if viewController.isKind(of: PBFeedsVC.self)
        {
            self.disableButtons([self.feedButton])
            self.selectedButton = self.feedButton
        }
        else if viewController.isKind(of: PBCaptureMediaVC.self)
        {
            self.disableButtons([self.newPostButton])
            self.selectedButton = self.newPostButton
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
        }
        else if viewController.isKind(of: PBFeedsVC.self)
        {
            self.disableButtons([self.profileButton])
            self.selectedButton = self.profileButton
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


