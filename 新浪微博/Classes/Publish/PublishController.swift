//
//  PublishController.swift
//  新浪微博
//
//  Created by A1 on 2016/10/19.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

let edgeMargin: CGFloat = 15
let iconCellId: String = "iconCellId"

class PublishController: UIViewController {
    
    //文本输入框
    @IBOutlet weak var publishTextView: PublishTextView!
    //工具条距离底部的距离
    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    //图片展示view
    @IBOutlet weak var picPickView: UICollectionView!
    //图片展示view的高度
    @IBOutlet weak var picPickViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        //设置图片选择器的基本属性
        setupPicPickView()

        //监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(PublishController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame , object: nil)
        
        //注册添加图片的通知 PickIconAddButtonClickNotification
        NotificationCenter.default.addObserver(self, selector: #selector(PublishController.pickIconAddButtonClick), name: NSNotification.Name(rawValue: PickIconAddButtonClickNotification) , object: nil)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        publishTextView.becomeFirstResponder()
    }
    
    //点击弹出图片
    @IBAction func picPickButtonClick(_ sender: AnyObject) {
        
        //退出键盘
        publishTextView.resignFirstResponder()
        
        picPickViewHeight.constant = UIScreen.main.bounds.height * 0.65
        
        UIView.animate(withDuration: 0.3) { 
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    //移除通知
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension PublishController: UIActionSheetDelegate {

    

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
        
        
        publishTextView.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    func publishStatus (){
        
    }
}

//MARK:- textView代理方法
extension PublishController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        
        self.publishTextView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        publishTextView.resignFirstResponder()
    }
}

extension PublishController {

    //键盘位置改变事件
    @objc func keyboardWillChangeFrame(_ note: NSNotification) {
        
        //获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        // 2.取出键盘最终的位置
        let endFrame = ((note as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // 3.计算弹出高度
        let margin = UIScreen.main.bounds.height - endFrame.origin.y
        
        // 4.执行动画
        toolBarBottomConstraint.constant = margin
        UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}


//MARK:- 图片的添加和删除
extension PublishController {

    //添加图片按钮的点击事件
    func pickIconAddButtonClick() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "进入相册", style: .default) { (_) in
            
            print("libraryAction")
        }
        
        let creameAction = UIAlertAction(title: "打开相机", style: .default) { (_) in
            
            print("creameAction")
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
            print("cancelAction")
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(libraryAction)
        alertController.addAction(creameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}

//MARK:- UICollectionViewDataSource

extension PublishController:UICollectionViewDataSource {
    
    func setupPicPickView() {
        
        picPickView.dataSource = self
        
        picPickView.register(IconCell.self, forCellWithReuseIdentifier: iconCellId)
        
        let layout = picPickView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (UIScreen.main.bounds.width - 4.0 * edgeMargin) / 3.0
        
        layout.itemSize = CGSize(width:itemWH, height: itemWH)
        
        layout.minimumLineSpacing = edgeMargin
        
        layout.minimumInteritemSpacing = edgeMargin
        
        //设置内边距
        picPickView.contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iconCellId, for: indexPath) as! IconCell
        
        return cell
    }
}

