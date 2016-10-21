//
//  CustomPresentationController.swift
//  新浪微博
//
//  Created by A1 on 2016/9/29.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    
    //MARK:- 蒙蔽懒加载
    lazy var coverView : UIView = UIView()
    
    
    
    //重写被弹出的容器view的layout方法，拿到被弹出的view并将位置和尺寸改变
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        
        let width = UIScreen.main.bounds.width * 0.6
        
        let x = (UIScreen.main.bounds.width - width) * 0.5
        
        presentedView?.frame = CGRect(x:x, y: 58, width: width, height: width * 1.5)
        
        //MARK:- 添加蒙蔽
        setupCoverView()
        
    }
}

extension CustomPresentationController {
    
    func setupCoverView() {
        
        //添加蒙蔽
        containerView?.insertSubview(coverView, at: 0)
        
        //设置蒙蔽的属性
        coverView.backgroundColor = UIColor(white: 0.6, alpha: 0.2)
        
        coverView.frame = containerView!.bounds
        
        //添加手势
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(CustomPresentationController.tap))
        
        coverView.addGestureRecognizer(tapGest)
    }
}


extension CustomPresentationController {
    
    func tap()  {
        
        presentedViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
}

