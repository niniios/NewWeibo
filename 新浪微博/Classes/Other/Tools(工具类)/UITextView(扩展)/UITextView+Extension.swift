//
//  UITextView+Extension.swift
//  新浪微博
//
//  Created by A1 on 2016/10/23.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

extension UITextView{

    //插入表情
    func insertEmoticon(emoticon: Emotion){
        
        //emoji表情
        if emoticon.emojiCode != nil {
            
            let textRange =  selectedTextRange!
            
             replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        //MARK:- 普通表情==图文混排
        
        //创建属性字符串
        let attachment = EmoticonAttrchment()
        
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        
        let font =  self.font!
        
        attachment.bounds = CGRect(x: 0, y: -3.5, width: font.lineHeight, height: font.lineHeight)
        
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        //创建可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range =  selectedRange
        
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        //显示属性字符串
         attributedText = attrMStr
        
        //文字大小重置
         self.font = font
        
        //光标位置
         selectedRange = NSRange(location: range.location + 1, length: 0)
    
    }
    //解析表情
    func resolveEmoticonString() -> String {
    
        //获取属性字符串
        let attrMString = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMString.length)
        
        attrMString.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            //用户输入了表情,将表情和chs兑换
            if let attrahment = dict["NSAttrchemt"] as? EmoticonAttrchment {
                
                attrMString.replaceCharacters(in: range, with: attrahment.chs!)
            }
        }
        
       return attrMString.string
    }

}
