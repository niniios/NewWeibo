//
//  PhotoCell.swift
//  新浪微博
//
//  Created by Hangshao on 2016/10/19.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var picUrl: URL? {
        
        didSet {
            
            guard let picUrl = picUrl else {
                
                return
            }
            
            //创建 iconView
            let iconView: UIImageView = UIImageView()
            
            //设置iconView的基本属性
            
            let itemWH = (UIScreen.main.bounds.width - 2.0 * 15.0 - 2.0 * 5.0) / 3.0
            
            iconView.frame = CGRect(x: 0, y: 0, width: itemWH, height: itemWH)
            
            iconView.sd_setImage(with: picUrl, placeholderImage: UIImage(named: "empty_picture"))
            
            //设置图片的填充为全部填充并且裁剪掉多余部分
            iconView.contentMode = UIViewContentMode.scaleAspectFill
            
            iconView.clipsToBounds = true
            
            contentView.addSubview(iconView)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
