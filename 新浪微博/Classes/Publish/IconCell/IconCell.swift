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
    
    lazy var addButton: UIButton = UIButton()
    
    lazy var deleteButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        
        addButton.frame = CGRect(x: 0, y: 0, width: itemWH, height: itemWH)
        addButton.setBackgroundImage(UIImage(named:"compose_pic_add"), for: .normal)
        addButton.setBackgroundImage(UIImage(named:"compose_pic_add_highlighted"), for: .highlighted)
        
        //添加图片的事件
        addButton.addTarget(self, action: #selector(IconCell.addButtonDidClick), for: .touchUpInside)
        
        addSubview(addButton)
        
        deleteButton.frame = CGRect(x: itemWH - 25, y: 0, width: 25, height: 25)
        deleteButton.isHidden = true
        deleteButton.setBackgroundImage(UIImage(named:"compose_photo_close"), for: .normal)
        deleteButton.setBackgroundImage(UIImage(named:"compose_photo_close"), for: .highlighted)

        addSubview(deleteButton)
    }
    
    func addButtonDidClick() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PickIconAddButtonClickNotification), object: nil)
    }
}
