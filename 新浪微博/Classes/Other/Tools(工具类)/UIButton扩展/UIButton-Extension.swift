//
//  UIButton-Extension.swift
//  新浪微博
//
//  Created by A1 on 2016/9/28.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

extension UIButton {
    //使用便利构造函数扩充类的方法
    
    convenience init (imageName:String, bgImageName:String) {
    
        //遍历构造函数必须调用本类的init结束
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
    
    }
}
