//
//  PhotoBr0wserController.swift
//  新浪微博
//
//  Created by A1 on 2016/10/24.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class PhotoBr0wserController: UIViewController {
    
    //下标
    var indexPath: IndexPath
    var picUrls: [URL]
    
    
    //图片数组
    init(inexPahth: IndexPath, urls: [URL]){
    
        self.indexPath = inexPahth
        
        self.picUrls = urls
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}
