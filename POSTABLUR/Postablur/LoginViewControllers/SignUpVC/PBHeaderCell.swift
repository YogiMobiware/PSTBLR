//
//  PBHeaderCell.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/18/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

protocol PBHeaderCellDelegate {
    
    func pbBackBtnDidTap()
    
}
class PBHeaderCell: UITableViewCell {

    var delegate : PBHeaderCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func backBtnAction(_ sender: UIButton)
    {
        if let delegate = self.delegate
        {
            delegate.pbBackBtnDidTap()
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
