//
//  TitleButton.swift
//  新浪微博
//
//  Created by A1 on 2016/9/29.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    //重写init(frame: CGRect) 方法
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
        
    }
    
    //重写了控件的 init(frame: frame) 或者是 init方法，必须重写init?(coder aDecoder: NSCoder) 方法，
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.titleLabel?.frame.origin.x = 0;
        
        self.imageView?.frame.origin.x = self.titleLabel!.frame.size.width + 5
        
    }
    
}
