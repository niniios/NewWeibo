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
    
    //记录是否是第一次进入控制器的标识
    var isPushKeyboard: Bool = true
    
    //存放选中的图片数组
    lazy var selectedImagesArray = [UIImage]()
    lazy var selectedAssetsArray = [Any]()
    
    //文本输入框
    @IBOutlet weak var publishTextView: PublishTextView!
    //工具条距离底部的距离
    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    //图片展示view
    @IBOutlet weak var picPickView: UICollectionView!
    //图片展示view的高度
    @IBOutlet weak var picPickViewHeight: NSLayoutConstraint!
    
    //表情键盘控制器
    lazy var emotionController: EmotionController = EmotionController {[weak self] (emoticon) in
        
        self?.textViewDidChange(self!.publishTextView)
        
        //拿到表情，插入文本框
        self?.publishTextView.insertEmoticon(emoticon: emoticon)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        //设置图片选择器的基本属性
        setupPicPickView()
        
        //监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(PublishController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublishController.deleteInputText), name: NSNotification.Name(rawValue: DeleteInputTextNotification), object: nil)
        
    }
    
    func deleteInputText() {
        
        if publishTextView.hasText ,publishTextView.attributedText.length > 0 {
            
            publishTextView.deleteBackward()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if isPushKeyboard {
        
            publishTextView.becomeFirstResponder()
            isPushKeyboard = false
        }
        
    }
    
    //工具条点击弹出图片容器事件
    
    @IBAction func toolBarIconPickButtonClick(_ sender: AnyObject) {
        //退出键盘
        publishTextView.resignFirstResponder()
        
        picPickViewHeight.constant = UIScreen.main.bounds.width + 44.0
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    //工具条表情点击切换键盘
    @IBAction func toolBarEmotionButtonClick(_ sender: AnyObject) {
        
        //退出键盘
        publishTextView.resignFirstResponder()
        
        //切换键盘
        publishTextView.inputView = publishTextView.inputView != nil ? nil :  emotionController.view
        
        
        //弹出键盘
        publishTextView.becomeFirstResponder()
    }
    
    //移除通知
    deinit {
        
        NotificationCenter.default.removeObserver(self)
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
        
        publishTextView.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- 发送微博
    func publishStatus (){
        
        //退出键盘
        publishTextView.resignFirstResponder()
        
        //显示提示框
        SVProgressHUD.show(withStatus: "发送中...")
        
        let text = publishTextView.resolveEmoticonString
        
        let image = selectedImagesArray.first
        
        //定义回调显示闭包
        let showResultCallBack = {(isSuccess: Bool) -> () in
        
            SVProgressHUD.dismiss()
            
            if isSuccess {
                
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                
                self.dismiss(animated: true, completion: {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: SuccessSendStatusNotification), object: nil)
                })
                
            } else {
                
                SVProgressHUD.showError(withStatus: "发送失败")
            }
        }
        
        //带有图片的微博
        if image != nil {
            
            NetWorkTool.shareInstance.sendStatus(statusText: text(), image: image!, isSuccess: showResultCallBack)
            
            //没有文字的微博
        } else {
            
            NetWorkTool.shareInstance.sendStatus(statusText: text(), isSuccess: showResultCallBack)
        }
    }
}

//MARK:- textView代理方法
extension PublishController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.publishTextView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
        self.publishTextView.placeHolderLabel.isHidden = textView.attributedText.length > 0
        
        navigationItem.rightBarButtonItem?.isEnabled = textView.attributedText.length > 0
        
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


//MARK:- UICollectionViewDataSource

extension PublishController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //设置collectinView基本属性
    func setupPicPickView() {
        
        picPickView.register(IconCell.self, forCellWithReuseIdentifier: iconCellId)
        
        let layout = picPickView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (UIScreen.main.bounds.width - 4.0 * edgeMargin) / 3.0
        
        layout.itemSize = CGSize(width:itemWH, height: itemWH)
        
        layout.minimumLineSpacing = edgeMargin
        
        layout.minimumInteritemSpacing = edgeMargin
        
        //设置内边距
        picPickView.contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
        //设置不能滚动
        picPickView.isScrollEnabled = false
    }
    
    //设置多少显示
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return selectedImagesArray.count + 1
    }
    
    //返回具体的cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iconCellId, for: indexPath) as! IconCell
        
        if indexPath.row == selectedImagesArray.count {
            
            cell.iconView.image = UIImage(named: "compose_pic_add_highlighted")
            cell.deleteButton.isHidden = true
            
        } else {
            
            cell.iconView.image = selectedImagesArray[indexPath.row]
            cell.deleteButton.isHidden = false
        }
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton .addTarget(self, action: #selector(PublishController.deleteImage(button:)), for: .touchUpInside)
        return cell;
    }
    
    //cell点击时间
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        publishTextView.resignFirstResponder()
        if indexPath.row == selectedImagesArray.count {
            pushImagePickerController()
        }
    }
}

//MARK:- 图片的添加和删除
extension PublishController: TZImagePickerControllerDelegate{
    
    //添加图片
    func pushImagePickerController() {
        
        let imagePickerVc = TZImagePickerController(maxImagesCount: 9, columnNumber: 3, delegate: self, pushPhotoPickerVc: true)
        
        //如果有图片进入选择图片时展示已经选中的图片
        imagePickerVc?.selectedAssets = selectedAssetsArray as! NSMutableArray
        
        present(imagePickerVc!, animated: true, completion: nil)
    }
    
    //代理：照片选择完毕
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        
        selectedImagesArray = photos
        
        selectedAssetsArray = assets
        
        
        picPickView.reloadData()
    }
    
    //删除照片
    func deleteImage(button: UIButton) {
        
        publishTextView.resignFirstResponder()
        selectedImagesArray.remove(at: button.tag)
        selectedAssetsArray.remove(at: button.tag)
        picPickView.performBatchUpdates({
            
            let indexpath = NSIndexPath(row: button.tag, section: 0)
            self.picPickView.deleteItems(at: [indexpath as IndexPath])
            
        }) { (_) in
            self.picPickView.reloadData()
        }
    }
}

