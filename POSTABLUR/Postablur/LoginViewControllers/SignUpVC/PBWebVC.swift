//
//  PBWebVC.swift
//  Postablur
//
//  Created by Saraschandra on 29/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class PBWebVC: UIViewController,UIWebViewDelegate
{

    @IBOutlet var navBarView: UIView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var termsWebView: UIWebView!
    
    var urlValue = ""
    var titleString = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        termsWebView.delegate = self
        if let url = URL(string: urlValue)
        {
            let request = URLRequest(url: url)
            termsWebView.loadRequest(request)
        }
        
        mainLabel.text = titleString
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        if (error as NSError).code == NSURLErrorCancelled
        {
            return
        }
        
        //IF NO INTERNET AVAILABLE NEED TO DISPLAY ALERT
        self.appDelegate.alert(vc: self, message: "Problem occurred while loading information. Please try later. \(String(describing: error.localizedDescription))", title: "Error")
    }
    
    
    @IBAction func closeBtnAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
