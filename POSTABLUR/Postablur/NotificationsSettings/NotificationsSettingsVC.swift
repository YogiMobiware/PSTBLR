//
//  NotificationsSettingsVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/29/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

let notifHeadersInfoArray : [String] = ["LIKES","COMMENTS","CONNECTIONS","REPORT/ABUSE"]

let likesArray : [String] = ["Notify me for each Like I get.","Notify me for each DisLike I get.","Notify me for each Like goal I hit."]

let commentsArray : [String] = ["Notify me for each Comment I get."]

let connectionsArray : [String] = ["Notify me for each Connect I get.","Notify me per every 100 Connects."]

let reportArray : [String] = ["Notify me for each Report I get."]


class NotificationsSettingsVC: UIViewController {

    var appdelegate : AppDelegate!
    
    @IBOutlet weak var notificationsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerNib = UINib(nibName: NibNamed.AccountsSettingsCell.rawValue, bundle: nil)
        self.notificationsTableView.register(headerNib, forCellReuseIdentifier: CellIdentifiers.AccountsSettingsCellIdentifier.rawValue)
        
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate

    }
    @IBAction func backBtnAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: Tableview Datasource and Delegate
extension NotificationsSettingsVC : UITableViewDataSource, UITableViewDelegate
{
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return notifHeadersInfoArray.count
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
        let rect = CGRect(origin: CGPoint(x: 20,y :5), size: CGSize(width: self.notificationsTableView.frame.size.width, height: 20.0))
        let headerView:UIView! = UIView (frame:rect)
        headerView.backgroundColor = Constants.headerTileColor
        let label = UILabel()
        label.frame = headerView.frame
        label.text = notifHeadersInfoArray[section]
        label.textColor = UIColor.lightGray
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return likesArray.count
        case 1:
            return commentsArray.count
        case 2:
            return connectionsArray.count
        default:
            return reportArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AccountsSettingsCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AccountsSettingsCellIdentifier.rawValue, for: indexPath) as! AccountsSettingsCell
        cell.arrowImage.isHidden = true
        switch indexPath.section
        {
        case 0:
            cell.accountsLabel?.text =  likesArray[indexPath.row]
            break
        case 1:
            cell.accountsLabel?.text =  commentsArray[indexPath.row]
            break
        case 2:
            cell.accountsLabel?.text =  connectionsArray[indexPath.row]
            break
        default:
            cell.accountsLabel?.text =  reportArray[indexPath.row]
            break
        }
        cell.backgroundColor = UIColor.clear
        
        let notifSwitch = UISwitch(frame: CGRect.zero) as UISwitch
        notifSwitch.isOn = false
        notifSwitch.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)
        notifSwitch.tag = indexPath.row
        cell.accessoryView = notifSwitch

        return cell
    }
    
    @objc func switchTriggered(sender: UISwitch) {
    
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.section == 2
        {
            if indexPath.row == 4
            {
               
            }
        }
    }
}

