//
//  AppDelegate.swift
//  新浪微博
//
//  Created by A1 on 2016/9/27.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var defaultVC : UIViewController? {
    
        let isLog = UserAccountViewModel.shareInstance.isLogin
        return isLog ? WelcomeViewController() : UINavigationController(rootViewController: HomeViewController())
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        
        window?.backgroundColor = UIColor.white
        
        window?.frame = UIScreen.main.bounds
        
        window?.rootViewController = defaultVC
        
        window?.makeKeyAndVisible()
        
        //设置全局导航栏按钮文字的颜色
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        return true
    }
}

