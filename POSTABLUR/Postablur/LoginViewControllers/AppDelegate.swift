//
//  AppDelegate.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/17/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
import Alamofire
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?

    var navigationController: UINavigationController?

    var hud : MBProgressHUD = MBProgressHUD()
    
    var registrationType = 1
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.loadLogin()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "ifeAkthu6TFg1kTLkapF8bAAW", consumerSecret:"jFU9sRnAecICwaU9wjLf25EV9C5PFca5AiSh2UG9rOLc1I3KGt")

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        var handled:Bool!
        
        if(registrationType == 2)
        {
            handled = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }
        else if (registrationType == 3)
        {
            handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        return handled
        
    }
    
    func loadLogin()
    {
        self.navigationController = UINavigationController()
        
        let loginController : UIViewController = PBLoginOptionsVC(nibName:NibNamed.PBLoginOptionsVC.rawValue, bundle:nil)
        self.navigationController!.pushViewController(loginController, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
    }
    
    func loadTabsContainer()
    {
        let tabsContainer = PBTabsContainerVC()
        self.navigationController?.popToRootViewController(animated: false)
        self.window?.rootViewController = tabsContainer
    }
    
    // MARK: Connectivity
    func isNetworkReachable() -> Bool
    {
        guard let isReachable = NetworkReachabilityManager()?.isReachable else
        {
            return false
        }
        
        return isReachable
    }
    
    // MARK: ACTIVITY INDICATOR
    func showActivityIndictor(titleString:NSString, subTitleString:NSString)
    {
        if let window = self.window
        {
            hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = titleString as String
            hud.detailsLabel.text = subTitleString as String
        }
    }
    
    func hideActivityIndicator(animated: Bool = true)
    {
        if let window = self.window
        {
            MBProgressHUD.hide(for: window, animated: animated)
        }
    }
    
    func alert(vc: UIViewController, message: String, title: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

