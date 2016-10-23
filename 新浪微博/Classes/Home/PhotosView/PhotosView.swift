//
//  PhotosView.swift
//  新浪微博
//
//  Created by Hangshao on 2016/10/19.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

class PhotosView: UICollectionView {
    
    var picUrls: [URL] = [URL]() {
        
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        
        dataSource = self
        delegate = self
        //注册Cell
        register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
}
// MARK:- 数据源和代理
extension PhotosView: UICollectionViewDataSource, UICollectionViewDelegate{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //拿到cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        //设置数据
        cell.picUrl = picUrls[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let showPhotoBrowserInfo = [ShowPhotoBrowserIndexPathKey: indexPath, ShowPhotoBrowserUrlArrayKey: picUrls] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNotification), object: showPhotoBrowserInfo)
        
    }
}


