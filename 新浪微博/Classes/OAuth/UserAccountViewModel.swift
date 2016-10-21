//
//  UserAccountTool.swift
//  新浪微博
//
//  Created by A1 on 2016/10/11.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    
    typealias SuccessCallBack = (Bool) -> ()
    //设计成单例
    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    
    var account : UserAccount?
    
    var isLogin: Bool {
        
        if account == nil {
            
            return false
        }
        
        //读取到信息
        guard let  exprise_date = account?.expires_date else {
            return false
        }
        
        return  exprise_date.compare(NSDate() as Date) == ComparisonResult.orderedDescending
        
    }
    
    //计算属性，用来返回信息地址
    var accountPath: String {
        
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        return (mainPath as NSString).appendingPathComponent("account.plist")
    }
    
    init() {
        
        //读取信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}

extension UserAccountViewModel {
    /// 加载accessToken
    func loadAccessToken(codeString : String, isSuccess : @escaping SuccessCallBack) {
        NetWorkTool.shareInstance.loadAccessToken(code: codeString) { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                print(error)
                isSuccess(false)
                return
            }
            
            // 2.获取结果,并且将结果转成模型对象
            guard let accountDict = result else {
                print("没有获取到账号信息")
                isSuccess(false)
                return
            }
            
            // 3.将字典转成模型对象
            let account = UserAccount(dict: accountDict as! [String : AnyObject])
            
            // 4.加载用户的信息
            self.loadUserInfo(account: account, isSuccess: isSuccess)
        }
    }
    
    /// 加载用户信息
    func loadUserInfo(account : UserAccount, isSuccess : @escaping SuccessCallBack) {
        // 1.判断accessToken和uid是否有值
        guard let accessToken = account.access_token, let uid = account.uid else {
            isSuccess(false)
            return
        }
        
        // 2.发送网络请求
        NetWorkTool.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) { (result, error) -> () in
            // 2.1.错误校验
            if error != nil {
                print(error)
                isSuccess(false)
                return
            }
            
            // 2.2.判断字典是否有值
            guard let userInfoDict = result else {
                print("没有获取到用户信息")
                isSuccess(false)
                return
            }
            
            // 2.3.获取用户的昵称和头像
            account.avatar_large = userInfoDict["avatar_large"] as? String
            account.screen_name = userInfoDict["screen_name"] as? String
            
            // 2.4.将对象归档
            NSKeyedArchiver.archiveRootObject(account, toFile: self.accountPath)
            self.account = account
            
            // 2.5.成功加载个人信息
            isSuccess(true)
        }
    }
}
