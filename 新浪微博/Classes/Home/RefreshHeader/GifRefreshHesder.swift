//
//  GifRefreshHesder.swift
//  新浪微博
//
//  Created by A1 on 2016/11/2.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class RotationGifRefreshHesder: MJRefreshGifHeader {
    
    //创建并添加自定义的控件
    override func prepare() {
        
        super.prepare()
        
        self.stateLabel.isHidden = true
        
        self.lastUpdatedTimeLabel.isHidden = true
        
        //设置下拉控件git的高度
        self.mj_h = 70
        
        var images:[UIImage] = [UIImage]()
        
        for i in 0...22 {
            
            let image = UIImage(named: "gif\(22 - i)")
            
            images.append(image!)
            images = images + images
        }
        
        self.setImages(images, for: .idle)
        self.setImages(images, for: .pulling)
        self.setImages(images, for: .refreshing)
    }
}
