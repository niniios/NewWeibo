//
//  HomeViewController.swift
//  新浪微博
//
//  Created by A1 on 2016/9/28.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //懒加载属性
    lazy var titleBtn : TitleButton = TitleButton()
    
    ///数据数组
    lazy var viewModelArray: [StatusViewModel] = [StatusViewModel]()
    
    ///提示文本框
    lazy var tipLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.判断是否登录
        if !isLogin { return }
        
        //设置导航栏内容
        setupNav()
        
        //设置tableView的基本样式
        setTableViewStyle()
        
        //注册首页更多操作的通知 HomeCellMoreOperationNotification
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.moreOperation), name: NSNotification.Name(rawValue: HomeCellMoreOperationNotification) , object: nil)
        
        //发布微博成功，刷新首页数据
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.refreshButtonClick), name: NSNotification.Name(rawValue: SuccessSendStatusNotification) , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showPhotoBrowser(noti:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNotification) , object: nil)
    }
}


//MARK:- 设置导航栏按钮
extension HomeViewController {
    func setupNav() {
        
        //设置标题
        self.title = UserAccountViewModel.shareInstance.account?.screen_name
        
        //设置左侧的按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(HomeViewController.refreshButtonClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: .plain, target: self, action: #selector(HomeViewController.publishBtnClick))
        
        //设置标题栏按钮
        titleBtn .setTitle("CoderYQ", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(button:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn;
    }
}

//MARK:- 导航栏的点击事件
extension HomeViewController {
    
    //顶部昵称按钮点击事件
    func titleBtnClick(button:TitleButton){
        
        button.isSelected = !button.isSelected
        
        let popVC = PopViewController()
        
        //设置弹出样式,让后面的视图依旧显示
        popVC.modalPresentationStyle = .custom
        
        //设置转场代理
        popVC.transitioningDelegate = self
        
        //弹出控制器
        present(popVC, animated: true, completion: nil)
    }
    
    //顶部右边发表按钮点击事件
    
    func refreshButtonClick(){
        
        tableView.mj_header.beginRefreshing()
    }
    
    //顶部右边发表按钮点击事件
    
    func publishBtnClick(){
        
        let publishVC = PublishController()
        
        let publishNav = UINavigationController(rootViewController: publishVC)
        
        present(publishNav, animated: true, completion: nil)
    }
}

//MARK:- 设置tableView的基本属性
extension HomeViewController  {
    
    func setTableViewStyle() {
        
        //设置Cell的分割线样式
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //设置cell的高度自动计算
        tableView.rowHeight = UITableViewAutomaticDimension
        //设置估算高度
        tableView.estimatedRowHeight = 200
        
        //创建下拉刷新控件
        let header = RotationGifRefreshHesder(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatus))
        
        
        tableView.mj_header = header
        //进入界面就开始加载数据
        tableView.mj_header.beginRefreshing()
        
        //创建上拉加载更多控件
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadOldStatus))
        
        footer?.stateLabel.isHidden = true
        tableView.mj_footer = footer
        
        
        //这是提示文本框的基本属性，并添加到导航栏上
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        tipLabel.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 32)
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.isHidden = true
    }
}

//MARK:- 转场代理
extension HomeViewController : UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    //实现代理里面的方法
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return CustomPresentationController(presentedViewController: presented, presenting: presented)
    }
    
    //实现动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //获取弹出的view
        let presentedView = transitionContext.view(forKey: .to)
        
        //设置锚点
        presentedView?.layer.anchorPoint = CGPoint(x: 0.3, y: 0)
        
        //将弹出的Viei添加到容器视图上
        transitionContext.containerView.addSubview(presentedView!)
        
        //执行动画
        presentedView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        
        UIView.animate(withDuration: 0.5, animations: {
            
            presentedView?.transform = CGAffineTransform.identity
            
        }) { (isFinished : Bool) in
            
            //完成动画
            transitionContext.completeTransition(true)
        }
    }
}

//MARK:- 获取微博数据
extension HomeViewController {
    
    //加载最新的数据
    func loadNewStatus() {
        
        tableView.mj_footer.endRefreshing()
        
        var since_id = 0
        
        if viewModelArray.count > 0 {
            
            since_id = (viewModelArray.first?.status?.mid)!
        }
        
        let max_id = 0
        
        NetWorkTool.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            //错误校验
            if error != nil{
                //停止刷新
                self.tableView.mj_header.endRefreshing()
                self.showTiplabel(count: 0, isError: true)
                return
            }
            
            guard  let resultArray = result else {
                
                //停止刷新
                self.tableView.mj_header.endRefreshing()
                self.showTiplabel(count: 0, isError: true)
                return
            }
            
            var tempViewModel = [StatusViewModel]()
            
            for statusDict in resultArray {
                
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            self.viewModelArray = tempViewModel + self.viewModelArray
            
            //刷新表格
            self.tableView.reloadData()
            //显示提示信息
            self.showTiplabel(count: tempViewModel.count, isError: false)
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    //加载更多的数据
    func loadOldStatus() {
        
        tableView.mj_header.endRefreshing()
        //获取到since_id
        let since_id = 0
        
        var max_id = viewModelArray.last?.status?.mid ?? 0
        max_id = max_id == 0 ? 0 : (max_id - 1)
        
        NetWorkTool.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            //错误校验
            if error != nil{
                //停止刷新
                self.tableView.mj_footer.endRefreshing()
                
                return
            }
            
            guard  let resultArray = result else {
                
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            var tempViewModel = [StatusViewModel]()
            
            for statusDict in resultArray {
                
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
                
            }
            
            self.viewModelArray += tempViewModel
            //刷新表格
            self.tableView.reloadData()
            //停止刷新
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    ///显示提示的文本框
    func showTiplabel(count: Int, isError: Bool) {
        
        if isError {
            
            tipLabel.text = "微博接口访问次数达到上限！"
            
        } else {
            
            count == 0 ? (tipLabel.text = "暂时没有新数据") : (tipLabel.text = "更新了\(count)条新微博")
        }
        
        tipLabel.isHidden = false
        
        UIView.animate(withDuration: 0.8, animations: {
            
            self.tipLabel.frame.origin.y = 44
            
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.8, delay: 0.8, options: [], animations: {
                    
                    self.tipLabel.frame.origin.y = 10
                    
                    }, completion: { (_) in
                        
                        self.tipLabel.isHidden = true
                })
        })
    }
}

//MARK:- tableView数据源
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell =  HomeCell.cellWithTableView(tableView)
            
            cell.viewModel = viewModelArray[indexPath.row]
        
            return cell
    }
}

//MARK:- 弹出照片浏览器的通知事件
extension HomeViewController {

    func showPhotoBrowser(noti: Notification) {
    
        let indexPath = noti.userInfo?[ShowPhotoBrowserIndexPathKey]! as! IndexPath
        
        //取出图片
        let picUrls = noti.userInfo?[ShowPhotoBrowserUrlArrayKey]! as! [URL]
        
        //创建控制器
        let browserVC = PhotoBr0wserController(inexPahth: indexPath, urls: picUrls)
        
        present(browserVC, animated: true, completion: nil)
        
    }
}

//MARK:- 更多操作选项
extension HomeViewController {
    
    func moreOperation() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let collectAction = UIAlertAction(title: "收藏", style: .default) { (_) in
            
        }
        
        let helpAction = UIAlertAction(title: "帮上头条", style: .default) { (_) in
            
        }
        
        let shieldAction = UIAlertAction(title: "屏蔽", style: .default) { (_) in
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(collectAction)
        alertController.addAction(helpAction)
        alertController.addAction(shieldAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
