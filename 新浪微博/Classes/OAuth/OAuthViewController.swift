//
//  OAuthViewController.swift
//  新浪微博
//
//  Created by A1 on 2016/10/11.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    
    //MARK:- 控件属性
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        //设置导航栏
        setupNavgationBar()
        
        loadOAuthPage()
    }
}

//MARK:- UI相关
extension OAuthViewController {
    
    func setupNavgationBar() {
        
        //设置标题
        title = "授权登录"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.leftBarButtonDidClick))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.rightBarButtonDidClick))
        
    }
    
    func loadOAuthPage() {
        
        //拼接请求地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&response_type=code&redirect_uri=\(redirect_uri)";
        
        //地址校验
        guard let url = NSURL(string: urlString) else {
            
            return
        }
        
        let request = NSURLRequest(url: url as URL)
        
        webView.loadRequest(request as URLRequest)
    }
}

//MARK:- 按钮的事件
extension OAuthViewController {
    
    //填充按钮点击事件
    func rightBarButtonDidClick() {
        
        //书写JS代码
        let jsCode = "document.getElementById('userId').value = 18883316269;"
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
    
    //关闭按钮点击事件
    func leftBarButtonDidClick() {
        
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- UIWebViewDelegate
extension OAuthViewController: UIWebViewDelegate {
    
    //开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show(withStatus: "加载中...")
        
    }
    
    //网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    
    //网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        SVProgressHUD.dismiss()
    }
    
    /// 当加载某一个页面时会执行该方法
    // 返回值 : 返回true,则继续加载.返回false,则停止加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取URL的字符串
        guard let urlString = request.url?.absoluteString else {
            print("没有获取到字符串")
            return true
        }
        // 2.判断是否有code,如果没有,则继续加载
        guard urlString.contains("code=") else {
            return true
        }
        // 3.截取code
        guard let codeString = urlString.components(separatedBy: "code=").last else {
            print("没有获取到code")
            return true
        }
        // 4.用code换取accessToken
        UserAccountViewModel.shareInstance.loadAccessToken(codeString: codeString) { (isSuccess) in
            
            if isSuccess {
                self.dismiss(animated: false, completion: { () -> Void in
                    
                    UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
                })
            }
        }
        return false
    }
}


