//
//  EmotionManager.swift
//  新浪微博
//
//  Created by A1 on 2016/10/23.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class EmotionManager: NSObject {
    
    //表情分组
    var packageArray: [EmotionPackage] = [EmotionPackage]()
    
    override init() {
            
        //1，默认表情的包
        packageArray.append(EmotionPackage(id: "com.sina.default"))
                
        //1，添加最近使用表情的包
        packageArray.append(EmotionPackage(id: "com.apple.emoji"))
                    
        //1，添加最近使用表情的包
        packageArray.append(EmotionPackage(id: "com.sina.lxh"))
        
        //1，添加删除的包
        packageArray.append(EmotionPackage(id: ""))
        
    }
    
}
