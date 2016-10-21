//
//  WelcomeViewController.swift
//  新浪微博
//
//  Created by A1 on 2016/10/13.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIImageView!
    
    //MARK:- 头像距离底部的距离约束
    @IBOutlet weak var iconViewBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置头像
        let iconString = UserAccountViewModel.shareInstance.account?.avatar_large
        let url = NSURL(string: iconString ?? "")
        
        iconView.sd_setImage(with: url! as URL, placeholderImage: UIImage(named: "avatar_default_big"))
        
        //修改约束
        iconView.frame.size = CGSize(width: 90, height: 90)
        iconViewBottomConstraint.constant = UIScreen.main.bounds.height - 200
        
        //执行动画 Damping：阻力系数 initialSpringVelocity：初始化速度
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 3.0, options: [], animations: {
            
            self.view.layoutIfNeeded()
            }) { (_) in
                //切换到住控制器
                UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        }
    }
}
