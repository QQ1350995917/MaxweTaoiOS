//
//  ShopingDetailViewCtr.swift
//  淘妈咪
//
//  Created by msk on 2017/3/28.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyButton
import Social
import SDWebImage
private let cellId = "DetailCell"
class ShopingDetailViewCtr: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let shopingTable = UITableView()
    let applyBtn = FlatButton()
    //全局lable 用于fooerView
    let footerLab = UILabel()
    //全局的 auctionModel
    var auctionModel = auctionDto()
    var goodDto:GoodsEntitiesDto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShopingTableView()
        setupTableHeaderView()
        setupTableFooterView()
        setupApplyBtn()
    }
    func setupShopingTableView(){
        shopingTable.frame = CGRect(x: 0, y: 64, width: WIDTH, height: HEIGHT-64)
        //去掉cell的横线
        shopingTable.separatorStyle = .none
        shopingTable.delegate=self
        shopingTable.dataSource=self
        shopingTable.sectionFooterHeight=0
        shopingTable.separatorInset=UIEdgeInsets.zero
        shopingTable.tableFooterView=UIView()
        shopingTable.rowHeight = 170
        //注册原型cell
        let cellNib = UINib(nibName: "ShopingDetailCell", bundle: nil)
        shopingTable.register(cellNib, forCellReuseIdentifier: cellId)
        self.view.addSubview(shopingTable)
    }
    
    func setupTableHeaderView(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 420))
        shopingTable.tableHeaderView = headerView
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 350))
        if let pictUrl = goodDto?.pictUrl {
            imgView.sd_setImage(with: URL.init(string:pictUrl), placeholderImage: UIImage(named: "img-placeholder"))
        }
        headerView.addSubview(imgView)
        
        let centerView = UIView(frame: CGRect(x: 0, y: 350, width: WIDTH, height: 70))
        headerView.addSubview(centerView)
        
        let titleLab = UILabel(frame: CGRect(x: 5, y: 0, width: WIDTH-10, height: 40))
        titleLab.font = UIFont.boldSystemFont(ofSize: 15)
        titleLab.textColor = RGB(r: 153, g: 153, b: 153)
        titleLab.numberOfLines = 0
        titleLab.text = goodDto.title
        centerView.addSubview(titleLab)
        
        let iconView = UIImageView(frame: CGRect(x: 5, y: 45, width: 20, height: 20))
        var iconName = ""
        if goodDto.userType == 0 {
            iconName = "taobao"
        }else if goodDto.userType == 1{
            iconName = "tianmao"
        }
        iconView.image = UIImage(named: iconName)
        iconView.layer.cornerRadius = 5
        iconView.clipsToBounds = true
        centerView.addSubview(iconView)
        
        let shopTitleLab = UILabel(frame: CGRect(x: 30, y: 45, width: WIDTH-35, height: 20))
        shopTitleLab.font = UIFont.systemFont(ofSize: 15)
        shopTitleLab.textColor = RGB(r: 153, g: 153, b: 153)
        shopTitleLab.text = goodDto.shopTitle
        centerView.addSubview(shopTitleLab)
    }
    func setupTableFooterView(){
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 120))
        footerView.backgroundColor = UIColor.white
        footerView.layer.borderColor = RGB(r: 51, g: 51, b: 51).cgColor
        footerView.layer.borderWidth = 1.0
        footerLab.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 120)
        footerLab.numberOfLines = 0
        footerLab.font = UIFont.systemFont(ofSize: 13)
        //给footerLab 添加长按手势
        footerLab.isUserInteractionEnabled = true
        let longTap = UILongPressGestureRecognizer()
        longTap.addTarget(self, action: #selector(footerLabTap))
        longTap.minimumPressDuration = 1
        footerLab.addGestureRecognizer(longTap)
        footerView.addSubview(footerLab)
        shopingTable.tableFooterView = footerView
        shopingTable.tableFooterView?.isHidden = true
    }
    func setupApplyBtn(){
        applyBtn.frame = CGRect(x: 10, y: HEIGHT-50, width: WIDTH-20, height: 45)
        applyBtn.setTitle("一键申请最高佣金", for: .normal)
        applyBtn.layer.borderColor = GREEN.cgColor
        applyBtn.layer.borderWidth = 1.0
        applyBtn.layer.cornerRadius = 25
        applyBtn.color = .white
        applyBtn.highlightedColor = GREEN
        applyBtn.cornerRadius = 25
        applyBtn.setTitleColor(GREEN, for: .normal)
        applyBtn.setTitleColor(UIColor.white, for: .highlighted)
        applyBtn.addTarget(self, action: #selector(applyBtnClickAction), for: .touchUpInside)
        self.view.addSubview(applyBtn)
    }
    func applyBtnClickAction(){
        applyBtn.isHidden = true
        //检测本地cookie是否过期 和 是否选择了推广位
        //判断两步
        //1> 有没有 cookie 需不需要登录淘宝
        testTaobaoLogin(completion: { (cookie) in
            let data:[String: Any] = cookie["data"] as! [String: Any]
            
            guard let noLogin = data["noLogin"] else{
                //2> 检验有没有选择推广位
                let sandBox = UserDefaults.standard
                let brandsIdDic = sandBox.value(forKey: "BrandsId")
                if brandsIdDic == nil{
                    self.showErrorText(status: "请先选择推广位")
                }else{
                    self.loadData()
                }
                return
            }
            let noLoginStr = String(describing: noLogin)
            if noLoginStr == "1"{
                let taobaoWeb = TBLoginWebViewController()
                self.present(taobaoWeb, animated: true, completion: {
                    
                })
            }
        })

        shopingTable.frame = CGRect(x: 0, y: 64, width: WIDTH, height: HEIGHT-114)
        shopingTable.setContentOffset(CGPoint(x:0,y:164), animated: true)
        shopingTable.tableFooterView?.isHidden = false
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 0, y: HEIGHT-50, width: WIDTH * 0.5, height: 50)
        leftBtn.setTitle("一键打开淘宝", for: .normal)
        leftBtn.setTitleColor(UIColor.white, for: .normal)
        leftBtn.backgroundColor = GREEN
        leftBtn.addTarget(self, action: #selector(openTaoBaoClickAction), for: .touchUpInside)
        self.view.addSubview(leftBtn)
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: WIDTH * 0.5, y: HEIGHT-50, width: WIDTH * 0.5, height: 50)
        rightBtn.setTitle("立即分享赚钱", for: .normal)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.backgroundColor = GREEN
        rightBtn.addTarget(self, action: #selector(shareClickAction), for: .touchUpInside)
        self.view.addSubview(rightBtn)
        
        let lineView = UIView(frame: CGRect(x: WIDTH * 0.5, y: HEIGHT-50, width: 0.5, height: 50))
        lineView.backgroundColor = RGB(r: 153, g: 153, b: 153)
        self.view.addSubview(lineView)
    }
    //加载 一键申请最高佣金 数据
    func loadData() {
        //获取淘宝商品转链
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   1    固定值
         sign	       String	     	签名
         cookie	       String	    	登录淘宝后的cookie
         auctionid	   number	    	商品的ID
         siteid	       number	     	导购推广ID
         adzoneid	   number	     	推广位的ID
         */
        let auctionUrl = auctionAccount()
        //取出沙盒
        let sandBox = UserDefaults.standard
        //取出沙盒中的字典
        let brandsIdDic:[String: Any] = sandBox.value(forKey: "BrandsId") as! [String : Any]
        let siteId:String = brandsIdDic["siteId"] as! String
        let adzoneid:String = brandsIdDic["id"] as! String
        
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let cookie = getStandCookie()
        let sign = GetSign()
        let auctionid = goodDto.auctionId ?? 0

        let auctionDic = ["t":t,
                         "id":id,
                         "cellphone":cellphone,
                         "apt":1,
                         "sign":sign,
                         "cookie":cookie,
                         "auctionid":auctionid,
                         "siteid":Int(siteId) as Any,
                         "adzoneid":Int(adzoneid) as Any] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: auctionUrl, parameters: auctionDic, succeed: { (result) in
            
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            
            if code == 200 {
                
                //给footerLable赋值
                let auctionDic:[String: Any] = result?["auction"] as! [String: Any]
                let auctionM = JSONDeserializer<auctionDto>.deserializeFrom(dict: auctionDic as NSDictionary?)
                self.auctionModel = auctionM!
                //文案 撰写
                let titleLab = self.goodDto.title ?? ""
                let kPriceLab = self.goodDto.zkPrice ?? 0
                var couponShortLinkUrlLab = self.auctionModel.couponShortLinkUrl ?? ""
                let couponLinkTaoTokenLab = self.auctionModel.couponLinkTaoToken ?? ""
                var shortLinkUrlLab = self.auctionModel.shortLinkUrl ?? ""
                let taoTokenLab = self.auctionModel.taoToken ?? ""
                
                
                if couponShortLinkUrlLab.characters.count == 0{
                    couponShortLinkUrlLab = self.auctionModel.couponLink ?? ""
                }
                if shortLinkUrlLab.characters.count == 0{
                    shortLinkUrlLab = self.auctionModel.clickUrl ?? ""
                }
                let titleText = "✌️\(titleLab)"
                //1>有优惠券的
                let priceText1 = "【券后价格】 ¥\(kPriceLab)"
                let linkText1 = "【领券下单】 \(couponShortLinkUrlLab)"
                let taoTokenText1 = "👆长按复制后打开📱淘宝👉\(couponLinkTaoTokenLab)👈"
                let footText = "以上是我为您精心推荐"
                //2>不带优惠券的
                let priceText2 = "【价格】 ¥\(kPriceLab)"
                let linkText2 = "【下单链接】 \(shortLinkUrlLab)"
                let taoTokenText2 = "👆长按复制后打开📱淘宝👉\(taoTokenLab)👈"
                
                //判断有没有优惠券显示不同的内容
                if let couponAmount = self.goodDto.couponAmount{
                    if couponAmount > 0 {
                        self.footerLab.text = "\(titleText)\n\(priceText1)\n\(linkText1)\n\(taoTokenText1)\n\(footText)"
                    }else{
                        self.footerLab.text = "\(titleText)\n\(priceText2)\n\(linkText2)\n\(taoTokenText2)\n\(footText)"
                    }
                }

             }else{
                self.showErrorHud(errorStr: message)
            }

        }) { (error) in
            
        }

    }
    //footerLable的手势响应方法
    func footerLabTap() {
        //判断有没有优惠券
        //判断一下有没有优惠券
        let couponAmount = goodDto?.couponAmount ?? 0
        if couponAmount > 0 {
            UIPasteboard.general.string = self.auctionModel.couponLinkTaoToken ?? ""
            self.showErrorText(status: "复制淘口令成功")
        }else{
            UIPasteboard.general.string = self.auctionModel.taoToken ?? ""
            self.showErrorText(status: "复制淘口令成功")
        }

    }
    func openTaoBaoClickAction(){
        let string = footerLab.text ?? ""
        //把内容添加到剪贴板
        UIPasteboard.general.string = string
        //打开淘宝
        let urlString = "taobao://item.taobao.com/item.htm?"
        let url = NSURL(string: urlString)
        UIApplication.shared.openURL(url! as URL)
        
    }
    func shareClickAction(){
        let string = footerLab.text ?? ""
        //把内容添加到剪贴板
        UIPasteboard.general.string = string
        var shareUrl: NSURL?
        //判断有没有优惠券
        if let couponAmount = self.goodDto.couponAmount{
            if couponAmount > 0 {
                shareUrl = NSURL(string: self.auctionModel.couponShortLinkUrl!)
            }else{
                shareUrl = NSURL(string: self.auctionModel.shortLinkUrl!)
            }
        }

        
        //找到缓存图片 找不到去缓存
        var pictImage = UIImage()
        SDImageCache.shared().queryDiskCache(forKey: self.goodDto.pictUrl) { (image:UIImage?, cacheType:SDImageCacheType) in
            pictImage = image!
        }
        //1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: string,
                                          images : pictImage,
                                          url : shareUrl! as URL!,
                                          title : self.goodDto.title!,
                                          type : SSDKContentType.auto)
        
        
        SSUIShareActionSheetStyle.setShareActionSheetStyle(.simple)
    
       
        //2.进行分享
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [AnyHashable : Any]?, contentEnity : SSDKContentEntity?, error : Error?, end) in

            switch state{
                
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.cancel:  print("分享取消")
                
            default:
                break
            }
        }

        
    }
    
    // MARK: - UITableViewDelegate && UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShopingDetailCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ShopingDetailCell
        cell.selectionStyle = .none
        cell.model = goodDto
        return cell
    }
    
    // MARK: - 系统方法
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
