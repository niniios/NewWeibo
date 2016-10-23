//
//  HomeCell.swift
//  新浪微博
//
//  Created by A1 on 2016/10/14.
//  Copyright © 2016年 A1. All rights reserved.
//

import UIKit

//private let edgeMargin : CGFont = 15 as! CGFont

class HomeCell: UITableViewCell {
    
    //MARK:- 控件属性
    
    @IBOutlet weak var operationButton: UIButton!
    //头像
    @IBOutlet weak var iconView: UIImageView!
    //认证图标
    @IBOutlet weak var varifiedView: UIImageView!
    //昵称
    @IBOutlet weak var screenNameLabel: UILabel!
    //认真图标
    @IBOutlet weak var vipView: UIImageView!
    //发布时间
    @IBOutlet weak var timeLabel: UILabel!
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    //微博正文
    @IBOutlet weak var contentLabel: UILabel!
    //转发的内容
    @IBOutlet weak var retweetedContentLabel: UILabel!
    //配图
    @IBOutlet weak var photosView: PhotosView!
    //转发背景图
    @IBOutlet weak var retweedBgView: UIView!
    
    
    //转发按钮
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK:- 约束属性
    //正文宽度
    @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
    //图片视图宽度和高度的约束
    @IBOutlet weak var photosViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photosViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var photosViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopConstraint: NSLayoutConstraint!
    
    //MARK:- 模型属性
    var viewModel: StatusViewModel? {
        
        didSet {
            
            //nil值校验
            guard let viewModel = viewModel else{
                return
            }
            
            //设置头像
            iconView.sd_setImage(with: viewModel.profileUrl, placeholderImage: UIImage(named: ""))
            
            //设置认证图标
            varifiedView.image = viewModel.verifiedImage
            
            //昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            (viewModel.vipImage == nil) ?  (screenNameLabel.textColor = UIColor.black) : (screenNameLabel.textColor = UIColor.orange)
            
            //会员图标
            vipView.image = viewModel.vipImage
            
            //设置时间
            timeLabel.text = viewModel.created_at_String
            
            //来源
            sourceLabel.text = viewModel.sourceString
            
            //正文
            let statusText =  viewModel.status?.text
            
            contentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: statusText, font: contentLabel.font)
            
            //设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name ,
                    let retweetedText = viewModel.status?.retweeted_status?.text {
                    
                    let retweetedContenText = "@"+"\(screenName): " + retweetedText
                    
                    retweetedContentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: retweetedContenText, font: retweetedContentLabel.font)
                    //设置转发正文距离顶部的约束
                    retweetedContentLabelTopConstraint.constant = 15
                }
                
                retweedBgView.isHidden = false
                
            } else {
                
                //设置转发正文距离顶部的约束
                retweetedContentLabelTopConstraint.constant = 0
                
                retweetedContentLabel.text = nil
                retweedBgView.isHidden = true
            }
            
            //计算并设置配图的尺寸
            let photosViewSize = calculatePhotosViewSize(count: viewModel.picUrls.count)
            photosViewWidthConstraint.constant = photosViewSize.width
            photosViewHeightConstraint.constant = photosViewSize.height
            //设置配图的数据
            photosView.picUrls = viewModel.picUrls
            
            //数值校验
            guard let reposts_count = viewModel.status?.reposts_count else {
                
                return
            }
            
            guard let comments_count = viewModel.status?.comments_count else {
                
                return
            }
            
            guard let attitudes_count = viewModel.status?.attitudes_count else {
                
                return
            }
            //设置数据
            reposts_count == 0 ?(repostButton.titleLabel?.text = "转发") : (repostButton.titleLabel?.text = "\(reposts_count)")
            comments_count == 0 ?(commentButton.titleLabel?.text = "评论") : (repostButton.titleLabel?.text = "\(comments_count)")
            attitudes_count == 0 ?(likeButton.titleLabel?.text = "点赞") : (likeButton.titleLabel?.text = "\(attitudes_count)")
        }
    }
}

//MARK:- 设置基本属性
extension HomeCell {
    
    //从xib中加载cell完毕就会调用
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //操作按钮的点击事件
        operationButton.addTarget(self, action: #selector(HomeCell.operationButtonDidClicked), for: .touchUpInside)
        
        // 设置圆角
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
        
        //设置微博正文的宽度
        contentWidthConstraint.constant = UIScreen.main.bounds.width - 30.0
        
        //取出配图的布局
        let photosViewLayout = photosView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //设置每个配图的大小
        let itemWH = (UIScreen.main.bounds.width - 2.0 * 15.0 - 2.0 * 5.0) / 3.0
        
        photosViewLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        photosViewLayout.minimumLineSpacing = 5
        
        photosViewLayout.minimumInteritemSpacing = 5
    }
    
}

// MARK: - 自定义的类方法从xib中快速创建cell
extension HomeCell {
    
    class func cellWithTableView(_ tableView: UITableView) -> HomeCell {
        
        let cellID = "HomeCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("HomeCell", owner: nil, options: nil)?.first as! HomeCell
        }
        
        cell?.selectionStyle = .none
        
        return cell as! HomeCell
    }
}

// MARK:- 计算配图的尺寸
extension HomeCell {
    
    func calculatePhotosViewSize(count: Int) -> CGSize {
        
        //没有配图直接设置为0
        if count == 0 {
            
            photosViewBottomConstraint.constant = 0;
            return CGSize(width: 0, height: 0)
        }
        
        photosViewBottomConstraint.constant = 10;
        
        //设置每个配图的大小
        let itemWH = (UIScreen.main.bounds.width - 2.0 * 15.0 - 2.0 * 5.0) / 3.0
        
        //四张配图
        if count == 4 {
            
            let photosViewWH = itemWH * 2 + 8.0
            return CGSize(width: photosViewWH, height: photosViewWH)
        }
        
        // 其它张配图
        //计算行数
        let row = (count - 1) / 3 + 1
        
        let photosViewW = itemWH * 3.0 + 5.0 * 2.0
        
        let photosViewH = CGFloat(row) * itemWH + (CGFloat(row) - 1.0) * 5.0
        
        return CGSize(width: photosViewW, height: photosViewH)
        
    }
}

// MARK:- 操作按钮的点击事件
extension HomeCell {

    func operationButtonDidClicked() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HomeCellMoreOperationNotification), object: nil)

    }
}
