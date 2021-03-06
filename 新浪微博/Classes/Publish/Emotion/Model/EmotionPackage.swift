//
//  EmotionPackage.swift
//  新浪微博
//
//  Created by A1 on 2016/10/23.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class EmotionPackage: NSObject {
    
    //表情数组
    var emotionArray: [Emotion] = [Emotion]()
    
    init(id: String) {
        
        //最近使用的表情
        if id == ""{
            return
        }
        
        //根据文件名拼接路径
        let infoPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        guard let array = NSArray(contentsOfFile: infoPath)! as? [[String: String]] else {
        
            return
        }
        
        for var dict in array {

            if let png = dict["png"] {
                
                dict["png"] = id + "/" + png
            }
            
            emotionArray.append(Emotion(dict: dict))
        }
    }
}
