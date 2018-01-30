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
    @IBOutlet var infoTextView : UITextView!
    
    var info: String!
    var titleString = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        mainLabel.text = titleString
        
        self.infoTextView.text = info
    }

   
    
    @IBAction func closeBtnAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
