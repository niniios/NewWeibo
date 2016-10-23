//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by A1 on 2016/10/19.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    
    var status: Status?
    
    /// 处理后的来源文字
    var sourceString: String?
    /// 处理后的时间
    var created_at_String: String?
    /// 处理后的认证图标
    var verifiedImage: UIImage?
    /// 处理后的等级图标
    var vipImage: UIImage?
    /// 处理后的等级用户头像
    var profileUrl: URL?
    /// 微博配图数组
    var picUrls: [URL] = [URL]()
    
    init(status: Status) {
        
        self.status = status
        
        //处理来源
        if let source = status.source , source != "" {
            
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            let realSource =  (source as NSString).substring(with: NSRange(location: startIndex, length: length))
            
            if realSource == "未通过审核应用" {
                
                sourceString = "来自火星CoderYQ的iPhone7Plus"
                
            } else {
                
                sourceString = "来自" + realSource
            }
            
        }
        //处理时间
        if let created_at = status.created_at {
            
            created_at_String = NSDate.createTimeWithString(timeString: created_at)
        }
        //处理认证图标
        let verified_type = status.user?.verified_type ?? -1
        
        switch verified_type {
            
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
            
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
            
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
            
        default:
            verifiedImage = nil
        }
        
        // 处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        
        if mbrank > 0 && mbrank <= 6 {
            
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        //处理头像
        let profile_image_String = status.user?.profile_image_url ?? ""
        profileUrl = URL(string: profile_image_String)
        
        //处理微博配图
        let picUrlDicts = (status.pic_urls!.count != 0) ? status.pic_urls : status.retweeted_status?.pic_urls
        
        if let picUrlDicts = picUrlDicts {
            //遍历数组，拿到字典
            for picUrlDict in picUrlDicts {
                
                guard let picUrlString = picUrlDict["thumbnail_pic"] else {
                    continue
                }
                //将处理好的图片路径直接装到数组中
                picUrls.append(URL(string: picUrlString)!)
            }
        }
    }
}
