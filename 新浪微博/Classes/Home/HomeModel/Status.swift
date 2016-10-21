//
//  Status.swift
//  新浪微博
//
//  Created by A1 on 2016/10/14.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    // MARK:- 属性
    /// 微博ID
    var id : Int = 0
    /// 用户ID
    var mid: Int = 0
    /// 微博正文
    var text : String?
    /// 来源
    var source : String?
    /// 发布时间
    var created_at : String?
    /// 转发次数
    var reposts_count: Int = 0
    /// 评论此时
    var comments_count: Int = 0
    /// 点赞次数
    var attitudes_count: Int = 0
    
    /// 用户模型
    var user: User?
    /// 配图数组
    var pic_urls: [[String: String]]?
    /// 转发微博
    var retweeted_status: Status?
    
    
    init(dict: [String : AnyObject]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
        //用户字典转用户模型
        let userDict = dict["user"] as! [String: AnyObject]
        
        user = User(dict: userDict)
        
        //转发微博转转发模型
        if let retweeredStatus = dict["retweeted_status"] as? [String: AnyObject] {
        
            retweeted_status = Status.init(dict: retweeredStatus)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
