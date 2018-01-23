//
//  RevealSettingsVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/20/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class RevealSettingsVC: UIViewController {
   
    var image : UIImage!
    var blurredImage : UIImage? = nil
    @IBOutlet weak var picImageView: UIImageView!

    @IBOutlet weak var unblurMsgTextLbl : UILabel!
    
    
    @IBOutlet weak var revealSettingsTableView: UITableView!
    @IBOutlet weak var revealTitleLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let likeNib = UINib(nibName: NibNamed.PBLikeLimitCell.rawValue, bundle: nil)
        self.revealSettingsTableView.register(likeNib, forCellReuseIdentifier: CellIdentifiers.PBLikeLimitCellIdentifier.rawValue)
        
        let shareNib = UINib(nibName: NibNamed.PBShareLimitCell.rawValue, bundle: nil)
        self.revealSettingsTableView.register(shareNib, forCellReuseIdentifier: CellIdentifiers.PBShareLimitCellIdentifier.rawValue)
        
        let dollarNib = UINib(nibName: NibNamed.PBDollarLimitCell.rawValue, bundle: nil)
        self.revealSettingsTableView.register(dollarNib, forCellReuseIdentifier: CellIdentifiers.PBDollarLimitCellIdentifier.rawValue)
       
        self.blurredImage =  PBUtility.blurEffect(image: image)
        
        self.picImageView.image = self.blurredImage
        let shareLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 24
        let roundedBoldfontSize = floor(shareLabelfontSize)
        self.revealTitleLabel.font = self.revealTitleLabel.font.withSize(roundedBoldfontSize)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func nextBtnAction(_ sender: UIButton)
    {
        let createNewPostVC = CreateNewPostVC()
        self.navigationController?.pushViewController(createNewPostVC, animated: true);

    }
    @IBAction  func unblurPhotoTapped(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true
        {
            self.picImageView.image = self.image
            self.unblurMsgTextLbl.text = "TAP TO BLUR PHOTO"
        }
        else
        {
            self.picImageView.image = self.blurredImage
            self.unblurMsgTextLbl.text = "TAP TO UNBLUR PHOTO"
        }
    }
}
// MARK: Tableview Datasource and Delegate
extension RevealSettingsVC : UITableViewDataSource, UITableViewDelegate
{
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
        return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 77.0)
       
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
            let cell : PBLikeLimitCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PBLikeLimitCellIdentifier.rawValue, for: indexPath) as! PBLikeLimitCell
            cell.likeLimitDelegate = self
            return cell
            
        case 1:
            let cell : PBShareLimitCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PBShareLimitCellIdentifier.rawValue, for: indexPath) as! PBShareLimitCell
            cell.shareLimitDelegate = self
            return cell
            
        case 2:
            let cell : PBDollarLimitCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PBDollarLimitCellIdentifier.rawValue, for: indexPath) as! PBDollarLimitCell
            cell.dollarLimitDelegate = self
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
}
// MARK: --
extension RevealSettingsVC : PBLikeLimitCellDelegate
{

    func oneLikeDidTap()
    {
        
    }
    func fiveLikeDidTap()
    {
        
    }
    func tenLikeDidTap()
    {
        
    }
}
extension RevealSettingsVC : PBShareLimitCellDelegate
{
    
    func oneShareDidTap()
    {
        
    }
    func fiveShareDidTap()
    {
        
    }
    func tenShareDidTap()
    {
        
    }
}
extension RevealSettingsVC : PBDollarLimitCellDelegate
{
    
    func oneDollarDidTap()
    {
        
    }
    func fiveDollarDidTap()
    {
        
    }
    func tenDollarDidTap()
    {
        
        
    }
}
