//
//  AccountSettingsVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/23/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class AccountSettingsVC: UIViewController {

    let headersInfoArray : [String] = ["CONNECTION INFORMATION","ACCOUNT INFORMATION","LEGAL INFORMATION"];
   
    let connectionInfoArray : [String] = ["FIND CONTACTS","INVITE CONTACTS"]
                                    
    let accInfoArray : [String] = ["EDIT ACCOUNT","CHANGE PASSWORD","ACCOUNT NOTIFICATIONS","ACCOUNT STATS"];

    let legalnfoArray : [String] = ["PRIVACY POLICY","TERMS AND CONDITIONS","ACCOUNT NOTIFICATIONS","ACCOUNT STATS","LOGOUT"];

    var appdelegate : AppDelegate!

    @IBOutlet weak var accountsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerNib = UINib(nibName: NibNamed.AccountsSettingsCell.rawValue, bundle: nil)
        self.accountsTableView.register(headerNib, forCellReuseIdentifier: CellIdentifiers.AccountsSettingsCellIdentifier.rawValue)
        
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   @IBAction func backBtnAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}
// MARK: Tableview Datasource and Delegate
extension AccountSettingsVC : UITableViewDataSource, UITableViewDelegate
{
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return headersInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45.0
    }
    
    private func tableView (_ tableView:UITableView , heightForHeaderInSection section:Int)->Float
    {
        return 20.0
    }
    
    func tableView (_ tableView:UITableView,  viewForHeaderInSection section:Int)->UIView?
    {
        let rect = CGRect(origin: CGPoint(x: 20,y :5), size: CGSize(width: self.accountsTableView.frame.size.width, height: 20.0))
        let headerView:UIView! = UIView (frame:rect)
        headerView.backgroundColor = Constants.headerTileColor
        let label = UILabel()
        label.frame = headerView.frame
        label.text = headersInfoArray[section]
        label.textColor = UIColor.lightGray
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return connectionInfoArray.count
        case 1:
            return accInfoArray.count
        default:
            return legalnfoArray.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AccountsSettingsCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AccountsSettingsCellIdentifier.rawValue, for: indexPath) as! AccountsSettingsCell
        switch indexPath.section
        {
        case 0:
            cell.accountsLabel?.text =  connectionInfoArray[indexPath.row]
            break
        case 1:
            cell.accountsLabel?.text =  accInfoArray[indexPath.row]
            break
        default:
            cell.accountsLabel?.text =  legalnfoArray[indexPath.row]
            break
        }
        cell.backgroundColor = UIColor.clear
            return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell : AccountsSettingsCell = tableView.cellForRow(at: indexPath) as! AccountsSettingsCell
        cell.accountsLabel.textColor = UIColor.black

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell : AccountsSettingsCell = tableView.cellForRow(at: indexPath) as! AccountsSettingsCell
        cell.accountsLabel.textColor = Constants.navBarTintColor

        if indexPath.section == 2
        {
            if indexPath.row == 4
            {
                print("add logout logic here")
                UserDefaults.standard.removeObject(forKey: "UserId")
                UserDefaults.standard.removeObject(forKey: "Email")
                UserDefaults.standard.removeObject(forKey: "Profileurl")
                UserDefaults.standard.removeObject(forKey: "UserName")
                UserDefaults.standard.synchronize()
                self.appdelegate.loadLogin()
            }
        }
    }
}
