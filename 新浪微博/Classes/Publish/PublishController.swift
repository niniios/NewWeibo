//
//  PublishController.swift
//  新浪微博
//
//  Created by A1 on 2016/10/19.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class PublishController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

    }
}

//MARK:- 导航栏的点击事件
extension PublishController {

    func setupNavigationBar (){
    
        //设置标题
        navigationItem.title = "发微博"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(PublishController.closePublishVC))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(PublishController.publishStatus))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    func closePublishVC (){
        
        dismiss(animated: true, completion: nil)
    }
    
    func publishStatus (){
        
    }
}
