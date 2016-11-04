# Swift版高仿新浪微博首页
![(logo)](https://github.com/CoderYQ/NewWeibo/blob/master/ScreenImages/05.png)
* A app which is similar to sina's app home page writed in Swift3.0
* 一款模仿新浪微博首页的Swift应用
  
  ## Contents
* Realized Function
        * [Use OAuth2.0 to register and login【使用OAuth2.0授权注册登录】](#使用OAuth2.0授权注册登录)
        * [Installation【如何使用MJRefresh】](#如何使用MJRefresh)
        * [Who's using【已经超过上百个App正在使用MJRefresh】](#已经超过上百个App正在使用MJRefresh)
        * [Classes【MJRefresh类结构图】](#MJRefresh类结构图)
* 常见API
	* [MJRefreshComponent.h](#MJRefreshComponent.h)
	* [MJRefreshHeader.h](#MJRefreshHeader.h)
	* [MJRefreshFooter.h](#MJRefreshFooter.h)
	* [MJRefreshAutoFooter.h](#MJRefreshAutoFooter.h)
* Examples
    * [Reference【参考】](#参考)
    * [下拉刷新01-默认](#下拉刷新01-默认)
    * [下拉刷新02-动画图片](#下拉刷新02-动画图片)
    * [下拉刷新03-隐藏时间](#下拉刷新03-隐藏时间)
    * [下拉刷新04-隐藏状态和时间](#下拉刷新04-隐藏状态和时间)
    * [下拉刷新05-自定义文字](#下拉刷新05-自定义文字)
    * [下拉刷新06-自定义刷新控件](#下拉刷新06-自定义刷新控件)
    * [上拉刷新01-默认](#上拉刷新01-默认)
    * [上拉刷新02-动画图片](#上拉刷新02-动画图片)
    * [上拉刷新03-隐藏刷新状态的文字](#上拉刷新03-隐藏刷新状态的文字)
    * [上拉刷新04-全部加载完毕](#上拉刷新04-全部加载完毕)
    * [上拉刷新05-自定义文字](#上拉刷新05-自定义文字)
    * [上拉刷新06-加载后隐藏](#上拉刷新06-加载后隐藏)
    * [上拉刷新07-自动回弹的上拉01](#上拉刷新07-自动回弹的上拉01)
    * [上拉刷新08-自动回弹的上拉02](#上拉刷新08-自动回弹的上拉02)
    * [上拉刷新09-自定义刷新控件(自动刷新)](#上拉刷新09-自定义刷新控件(自动刷新))
    * [上拉刷新10-自定义刷新控件(自动回弹)](#上拉刷新10-自定义刷新控件(自动回弹))
    * [UICollectionView01-上下拉刷新](#UICollectionView01-上下拉刷新)
    * [UIWebView01-下拉刷新](#UIWebView01-下拉刷新)
* [期待](#期待)

