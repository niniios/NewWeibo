//
//  UserAccount.swift
//  新浪微博
//
//  Created by A1 on 2016/10/11.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    var access_token : String?
    
    var avatar_url : NSURL?
    
    var uid : String?
    
    var expires_date : NSDate?
    
    var screen_name : String?
    
    var expires_in : TimeInterval = 0 {
        
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    var avatar_large : String? {
        
        didSet {
            avatar_url = NSURL(string: avatar_large ?? "")
        }
    }
    
    //MARK:- 自定义的构造函数
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    //某些字典的属性并没有，需要重写下面的方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    //MARK:- 重写description属性
    override var description: String {
        
        return dictionaryWithValues(forKeys: ["access_token", "uid", "screen_name", "expires_date", "avatar_large", "screen_name"]).description
    }
    
    
    //MARK:- 归档和解档
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_url, forKey: "avatar_url")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as? NSURL
    }
    
}
