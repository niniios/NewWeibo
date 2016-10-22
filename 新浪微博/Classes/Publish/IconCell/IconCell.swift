//
//  IconCell.swift
//  新浪微博
//
//  Created by A1 on 2016/10/21.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

let itemWH = (UIScreen.main.bounds.width - 4.0 * 15) / 3.0

class IconCell: UICollectionViewCell {
    
    //图片
    lazy var iconView: UIImageView = UIImageView()
    
    //删除按钮
    lazy var deleteButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        
        iconView.frame = CGRect(x: 0, y: 0, width: itemWH, height: itemWH)
        addSubview(iconView)
        
        deleteButton.frame = CGRect(x: itemWH - 20, y: -5, width: 25, height: 25)
        deleteButton.setBackgroundImage(UIImage(named:"compose_photo_close"), for: .normal)
        deleteButton.setBackgroundImage(UIImage(named:"compose_photo_close"), for: .highlighted)

        addSubview(deleteButton)
    }
}
