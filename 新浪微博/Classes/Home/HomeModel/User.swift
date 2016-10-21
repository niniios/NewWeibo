//
//  User.swift
//  新浪微博
//
//  Created by A1 on 2016/10/19.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class User: NSObject {

    /// 昵称
    var screen_name : String?
    /// 头像地址
    var profile_image_url : String?
    
    /// 认证类型
    var verified_type : Int = -1
    
    /// 会员等级
    var mbrank : Int = 0

    // MARK:- 构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
