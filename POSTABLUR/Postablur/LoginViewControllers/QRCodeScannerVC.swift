//
//  QRCodeScannerVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/20/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class QRCodeScannerVC: UIViewController {
    @IBOutlet weak var qrCodeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var scansCountLbl: UILabel!
    @IBOutlet weak var scannerImage: UIImageView!
    @IBOutlet var userImage: UIImageView!
    
    weak var tabContainerVC : PBTabsContainerVC!
    
    // MARK: Inits
    init()
    {
        super.init(nibName: NibNamed.QRCodeScannerVC.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
                if let userProfileUrlStr = UserDefaults.standard.object(forKey: "Profileurl") as? String
                {
                    if let userProfileUrl = URL(string: userProfileUrlStr)
                    {
                        self.userImage.kf.setImage(with: userProfileUrl)
                    }
                    else
                    {
                        self.userImage.image = UIImage.init(named: "default_avatar")
                    }
               }
               if let usernameStr = UserDefaults.standard.object(forKey: "UserName")
               {
                    let username = "@ \(usernameStr)"
                    self.nameLbl.text = username
               }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
   

}
