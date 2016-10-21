//
//  ALertTableView.swift
//  新浪微博
//
//  Created by Hangshao on 2016/10/21.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

//宽度
let AlertWidth = UIScreen.main.bounds.width

class AlertTableView: UIView {
   
    //标题数组
    var titlesArray = [String]()
    
    //取消按钮标题
    var cancelButtonTitle: String?
    
    //回调block
    typealias ClickBlock = (Int) -> Void
    
    var clickedAtIndex: ClickBlock?
    
    lazy var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    
    class func alertTableView(titles:[String], cancelButtonTitle: String, didClickedAtIndex: @escaping ClickBlock) {
    
        //创建视图
        let alertView = AlertTableView(frame: UIScreen.main.bounds)
        
        //赋值数组
        alertView.titlesArray = titles
        
        //存储取消按钮的文字
        alertView.cancelButtonTitle = cancelButtonTitle
        
        //赋值回调
        alertView.clickedAtIndex = didClickedAtIndex
        
        UIApplication.shared.keyWindow?.addSubview(alertView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //点击移除窗口
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            
            self.tableView.frame.origin.y = UIScreen.main.bounds.height
            
            }) { (_) in
                
                self.removeFromSuperview()
        }
    }
}

// MARK:- 添加并设置子控件
extension AlertTableView {
    
    //添加子控件
    func setupUI() {
        
        backgroundColor = UIColor(white: 0.1, alpha: 0.3)
        
        tableView.isScrollEnabled = false
        
        tableView.sectionFooterHeight = 0
        
        //设置数据源
        tableView.dataSource = self
        //设置代理
        tableView.delegate = self
        
        tableView.reloadData()
        
        addSubview(tableView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //设置tableView的尺寸
        let tableViewHeight = CGFloat(titlesArray.count + 1) * 44.0 + 4
        
        tableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - tableViewHeight, width: AlertWidth, height: tableViewHeight)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK:- 数据源和代理方法
extension AlertTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return titlesArray.count
            
        } else {
        
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textAlignment = .center
        
        if indexPath.section == 0 {
        
            cell.textLabel?.text = titlesArray[indexPath.row]
            return cell
            
        } else {
        
            cell.textLabel?.text = cancelButtonTitle
            return cell
        }
    }
}

extension AlertTableView: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
            return 0.1
            
        } else {
        
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect(x: 0, y: 0, width: AlertWidth, height: 1))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //点击了取消按钮
        if indexPath.section == 1 {
            
            print("取消")
            
        } else {
            //做事情
            if (clickedAtIndex != nil) {
                
                clickedAtIndex!(indexPath.row)
            }
        }
    }

}



