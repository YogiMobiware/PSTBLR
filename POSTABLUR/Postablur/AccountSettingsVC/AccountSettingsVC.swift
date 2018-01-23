//
//  AccountSettingsVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/23/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class AccountSettingsVC: UIViewController {

    @IBOutlet weak var accountsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerNib = UINib(nibName: NibNamed.AccountsSettingsCell.rawValue, bundle: nil)
        self.accountsTableView.register(headerNib, forCellReuseIdentifier: CellIdentifiers.AccountsSettingsCellIdentifier.rawValue)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: Tableview Datasource and Delegate
extension AccountSettingsVC : UITableViewDataSource, UITableViewDelegate
{
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
        return 44.0
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AccountsSettingsCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AccountsSettingsCellIdentifier.rawValue, for: indexPath) as! AccountsSettingsCell
            return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
}
