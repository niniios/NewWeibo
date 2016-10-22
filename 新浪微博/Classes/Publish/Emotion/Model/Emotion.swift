//
//  Emotion.swift
//  新浪微博
//
//  Created by A1 on 2016/10/23.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class Emotion: NSObject {

    var code: String?  {//emoji表情对应的code
    
        didSet{
        
            guard let code = code else {
                
                return
            }
            
            //创建扫描器
            let scanner = Scanner(string: code)
            
            //扫描得到code中的值
            var value: UInt32 = 0
            
            scanner.scanHexInt32(&value)
            
            //将值保存
            let c = Character(UnicodeScalar(value)!)
            
            //将字符转换成字符串
            emojiCode = String(c)
        }
    
    }
    
    var png: String? {//普通图片对应的名字

        didSet{
        
            guard let png = png else {
            
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + "" + png
        
        }
    }
    
    var chs: String? //普通表情对应的文字
    
    //表情图片的根目录
    var pngPath: String?
    
    //emoji表情的code
    var emojiCode: String?
    
    //
    var isRemove: Bool = false
    
    init(dict: [String: String]) {
        
        super.init()
    
        setValuesForKeys(dict)
        
    }
    
    init(isRemove: Bool) {
        
        self.isRemove = isRemove
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
    
        return dictionaryWithValues(forKeys: ["emojiCode", "pngPath","chs"]).description
    
    }
}
