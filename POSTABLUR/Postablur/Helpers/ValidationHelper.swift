//
//  ValidationHelper.swift
//  Foundmi
//
//  Created by Srinivas Peddinti on 2/10/17.
//  Copyright © 2017 MobiwareInc. All rights reserved.
//

import UIKit

class ValidationHelper
{
    static let requiredPasswordLength: Int = 6
    
    static func isValidEmail(emailStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }

}
