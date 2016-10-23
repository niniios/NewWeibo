//
//  Common.swift
//  新浪微博
//
//  Created by A1 on 2016/10/11.
//  Copyright © 2016年 A1. All rights reserved.
//

import Foundation

//MARK:- 授权常量
let app_key = "858550576"
let app_secret = "84b8e13f223173f7d797e22b155e38cf"
let redirect_uri = "http://www.cqut.edu.cn"

//发布微博界面的通知常量
let PickIconAddButtonClickNotification = "PickIconAddButtonClickNotification"
let HomeCellMoreOperationNotification = "HomeCellMoreOperationNotification"


//发布界面工具条点击删除按钮的通知
let DeleteInputTextNotification = "DeleteInputTextNotification"
//成功发布微博后的通知
let SuccessSendStatusNotification = "SuccessSendStatusNotification"


//点击cell中图片的通知
let ShowPhotoBrowserNotification = "ShowPhotoBrowserNotification"
//具体的 indexPath
let ShowPhotoBrowserIndexPathKey = "ShowPhotoBrowserIndexPathKey"
//图片地址数组
let ShowPhotoBrowserUrlArrayKey = "ShowPhotoBrowserUrlArray"
