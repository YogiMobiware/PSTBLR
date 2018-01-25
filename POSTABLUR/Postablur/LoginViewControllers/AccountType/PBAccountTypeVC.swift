//
//  PBAccountTypeVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/19/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class PBAccountTypeVC: UIViewController
{

    @IBOutlet weak var accountTypeTableView: UITableView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let headerNib = UINib(nibName: NibNamed.PBHeaderCell.rawValue, bundle: nil)
        self.accountTypeTableView.register(headerNib, forCellReuseIdentifier: CellIdentifiers.PBHeaderCellIdentifier.rawValue)

        let freeAccountNib = UINib(nibName: NibNamed.PBFreeAccountCell.rawValue, bundle: nil)
        self.accountTypeTableView.register(freeAccountNib, forCellReuseIdentifier: CellIdentifiers.PBFreeAccountCellIdentifier.rawValue)
        
        let paidAccountNib = UINib(nibName: NibNamed.PBPaidAccoutCell.rawValue, bundle: nil)
        self.accountTypeTableView.register(paidAccountNib, forCellReuseIdentifier: CellIdentifiers.PBPaidAccoutCellIdentifier.rawValue)

        self.appDelegate = UIApplication.shared.delegate as! AppDelegate

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

}
// MARK: Tableview Datasource and Delegate
extension PBAccountTypeVC : UITableViewDataSource, UITableViewDelegate
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
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 200.0)
        }
        else{
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 325.0)
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
            let cell : PBFreeAccountCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PBFreeAccountCellIdentifier.rawValue, for: indexPath) as! PBFreeAccountCell
            return cell
            
        case 2:
            let cell : PBPaidAccoutCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PBPaidAccoutCellIdentifier.rawValue, for: indexPath) as! PBPaidAccoutCell
            cell.paidDelegate = self
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
extension PBAccountTypeVC : PBPaidAccoutCellDelegate
{
    func pbnextBtnDidTap()
    {
        self.appDelegate.loadTabsContainer()

    }
}

// MARK: --  HEADER DELEGATES
extension PBAccountTypeVC : PBHeaderCellDelegate
{
    func pbBackBtnDidTap()
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
}

