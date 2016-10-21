//
//  BaseViewController.swift
//  新浪微博
//
//  Created by Hangshao on 2016/10/21.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    // MARK:- 懒加载属性
    lazy var loginView : LoginView = LoginView.loginView()
    
    // MARK:- 属性
    var isLogin : Bool = UserAccountViewModel.shareInstance.isLogin
    
    // MARK:- 系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setupLoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "用户登录"
    }
}

extension BaseViewController {
    
    func setupLoginView() {
        // 将访客视图作为根视图
        view = loginView
        loginView.loginButton.addTarget(self, action: #selector(HomeViewController.loginBtnClick), for: .touchUpInside)
    }
}

// MARK:- 事件监听函数
extension BaseViewController {

    func loginBtnClick() {
        // 1.创建授权页面
        let oauthVc = OAuthViewController()
        
        // 2.包装导航控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        // 3.弹出授权页面
        present(oauthNav, animated: true, completion: nil)
    }
}
