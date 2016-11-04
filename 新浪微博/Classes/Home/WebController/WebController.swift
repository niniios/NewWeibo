//
//  WebController.swift
//  新浪微博
//
//  Created by A1 on 2016/11/4.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class WebController: UIViewController {
    
    var urlString: String?
    
    @IBOutlet weak var webView: UIWebView!
    
    init(urlString:String) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.urlString = urlString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL.init(string: urlString!)
        
        let request = NSURLRequest(url: url!)
        
        webView.loadRequest(request as URLRequest)
    }
    
    deinit {
        
         SVProgressHUD.dismiss()
    }
}

extension WebController: UIWebViewDelegate {

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
}
