//
//  EmotionController.swift
//  新浪微博
//
//  Created by A1 on 2016/10/22.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

let EmotionCell: String = "EmotionCell"

class EmotionController: UIViewController {

    //显示表情的控件
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
    
    //表情管理器
    lazy var manager = EmotionManager()

    //切换工具条
    lazy var toolBar: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        prepareForCollectionView()
        
        prefareToolBar()
        
    }
}

extension EmotionController {

    func setupUI(){
    
        //添加控件
        collectionView.backgroundColor = UIColor.white
        toolBar.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        view.addSubview(toolBar)
    
        //设置控件的约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        //水平方向
        let views = ["collectionView" : collectionView, "toolBar" : toolBar]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar(44)]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
    }
    
    
    //设置基本属性
    func prepareForCollectionView() {
    
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: EmotionCell)
        
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.showsHorizontalScrollIndicator = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = UIScreen.main.bounds.width / 7.0
        
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        layout.minimumLineSpacing = 0
        
        layout.minimumInteritemSpacing = 0
        
        //水平滚动
        layout.scrollDirection = .horizontal
        
        let inset = (collectionView.bounds.height - 3.0 * itemWH) / 3.0
        
        collectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)

    }
    
    //设置toolBar的基本属性
    func prefareToolBar() {
    
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        var index: CGFloat = 0.0
        
        //计算宽度和高度
        let optionCardWidth = UIScreen.main.bounds.width / 4.0
        
        for title in titles {
            
            let button = UIButton()
            button.tag = Int(index)
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.orange, for: .normal)
            button.frame = CGRect(x: (index * optionCardWidth), y: 0, width: optionCardWidth, height: 44)
            button.addTarget(self, action: #selector(EmotionController.emotionOptionCardClick(button:)), for: .touchUpInside)
            index = index + 1.0
            toolBar.addSubview(button)
        }
    }
    
    //表情选项卡的点击效果
    func emotionOptionCardClick(button: UIButton){
        //点击了最新分组
        if button.tag == 0 {
        
            if manager.packageArray.first?.emotionArray.count != 0 {
                
                let indexPath = NSIndexPath(item: 0, section: button.tag)
                
                collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .left)
                
            }
            
        } else{
        
            let indexPath = NSIndexPath(item: 0, section: button.tag)
            
            collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .left)
        }
    }
}

extension EmotionController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        print(manager.packageArray.count)
        return manager.packageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packageArray[section]
        
        return package.emotionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell, for: indexPath) as! EmoticonCell
        
        let package = manager.packageArray[indexPath.section]
        
        cell.emoticon = package.emotionArray[indexPath.item]
        
        return cell
    }

}

