//
//  LoginView.swift
//  新浪微博
//
//  Created by A1 on 2016/9/28.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    @IBOutlet weak var loginButton: UIButton!
    class func loginView() -> LoginView {
        return Bundle.main.loadNibNamed("LoginView", owner: nil, options: nil)?.first as! LoginView
    }
}
