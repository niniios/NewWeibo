//
//  PublishTextView.swift
//  新浪微博
//
//  Created by A1 on 2016/10/21.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class PublishTextView: UITextView {
    // MARK:- 懒加载属性
    lazy var placeHolderLabel : UILabel = UILabel()
    
    // MARK:- 重写构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 添加展位的Label
        setupPlaceHolder()
    }
}

// MARK:- 设置UI界面内容
extension PublishTextView {
    /// 添加占位的Label
    func setupPlaceHolder() {
        // 1.添加添加的Label
        addSubview(placeHolderLabel)
        
        // 2.设置位置和尺寸
        placeHolderLabel.frame = CGRect(x: 10, y: 10, width: 200, height: 15)
        
        // 3.设置Label的属性
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.font = font
        placeHolderLabel.textColor = UIColor.lightGray       
        // 4.设置textView的左侧位置
        textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 0, right: 10)
    }
}
