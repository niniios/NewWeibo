//
//  NetWorkTool.swift
//  新浪微博
//
//  Created by A1 on 2016/10/11.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

enum RequestMethodType: String {
    
    case GET = "GET"
    case POST = "POST"
}

class NetWorkTool: AFHTTPSessionManager {
    
    typealias Completed = (_ result: AnyObject?, _ error: NSError?) -> ()
    
    typealias Finished = (_ result: [String : AnyObject]?, _ error: NSError) -> ()
    
    typealias CallBack = (_ result: String) -> ()
    
    static let shareInstance: NetWorkTool = {
        
        let tool = NetWorkTool()
        
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        tool.responseSerializer.acceptableContentTypes?.insert("application/json")
        tool.responseSerializer.acceptableContentTypes?.insert("text/json")
        tool.responseSerializer.acceptableContentTypes?.insert("text/javascript")
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tool
    }()
}

//MARK:- GET/POST请求方法的封装
extension NetWorkTool {
    
    func request(methodType:RequestMethodType, urlString: String, parameters: [String : AnyObject], completed: @escaping Completed) {
        
        // 1.封装成功的回调
        let successCallBack = { (task : URLSessionDataTask?, result : Any?) -> Void in
            
            guard let result = result else {
                
                return
            }
            
            completed(result as AnyObject?, nil)
        }
        
        // 2.封装失败的回调
        let failureCallBack = { (task : URLSessionDataTask?, error : Error?) -> Void in
            
            guard let error = error else {
                
                return
            }
            
            completed(nil, error as NSError?)
        }
        
        //判断是哪种请求方式
        if methodType == .GET {
            
            get(urlString, parameters: parameters, success: successCallBack, failure: failureCallBack)
            
        } else {
            
            post(urlString, parameters: parameters, success: successCallBack, failure: failureCallBack)
        }
    }
}

//MARK:- 请求AccessToken
extension NetWorkTool {
    
    func loadAccessToken(code: String, completed: @escaping Completed ) {
        
        //获取地址
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //获取参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : redirect_uri]
        
        //发送请求
        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            
            completed(result, error)
        }
    }
}


//MARK:- 请求用户信息
extension NetWorkTool {

    func loadUserInfo(access_token: String, uid: String, completed: @escaping Completed) {
        
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            
            completed(result, error)
        }
    }
}

//MARK:- 获取微博数据
extension NetWorkTool {

    func loadStatuses(since_id: Int, max_id: Int, comeleted : @escaping (_ results : [[String : AnyObject]]?, _ error : NSError?) -> ()) {
     
        //获取地址
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        
        //请求参数
        //参数校验，确定有值才可以进行下面的操作
        guard let access_token_String = UserAccountViewModel.shareInstance.account?.access_token else {
            return
        }        
        let paramters = ["access_token" : access_token_String, "since_id": "\(since_id)", "max_id": "\(max_id)"]
        
        //发送请求
        request(methodType: .GET, urlString: urlString, parameters: paramters as [String : AnyObject]) { (result, error) in
            
            guard let resultDict = result as? [String : AnyObject] else {
            
                comeleted(nil, error)
                return
            }
            
            comeleted(resultDict["statuses"] as? [[String : AnyObject]], error)
        }
    }
}


