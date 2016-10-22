//
//  EmoticonCel.swift
//  新浪微博
//
//  Created by A1 on 2016/10/23.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
    
    //模型属性
    var emoticon: Emotion? {
    
        didSet {
        
            guard let emoticon = emoticon else {
                return
            }
            //设置删除按钮
            if emoticon.isRemove {
                
                button.setImage(UIImage(named:"compose_pic_add_highlighted"), for: .normal)
                
            } else {
            
                //设置图片
                
                let image = UIImage(contentsOfFile: emoticon.pngPath ?? "")
                
                button.setImage(image, for: .normal)
                
                button.setTitle(emoticon.emojiCode, for: .normal)
            }
        }
        
    }
    
    //懒加载子控件
    lazy var button: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmoticonCell {

    func setupUI(){
    
        contentView.addSubview(button)
        
        button.frame = contentView.bounds
        
        button.isUserInteractionEnabled = false
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 33)
    
    }
}
