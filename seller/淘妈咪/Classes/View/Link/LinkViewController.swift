//
//  LinkViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import SwiftyButton
class LinkViewController: BaseViewController {

    //定义上边的视图
    let headerV = HeaderView()
    //textView
    var textView = UITextView()
    //粘贴按钮
    var PasteBtn = UIButton(title: "一键粘贴", fontSize: 15, normalColor: UIColor.darkGray, highlightedColor: GREEN)
    //获取淘口令按钮
    var getButton = PressableButton()
    //获取成功后显示的view 和中间的lable
    var lableView = UIView()
    var centerLable = UILabel()
    //懒加载创建接收数据的数组
    lazy var statusList = [GoodsEntitiesDto]()
    //当前页面请求成功后返回的model
    var goodDto:GoodsEntitiesDto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏掉导航栏
        navigationBar.isHidden = true

        setupUI()
    }
    //一键粘贴按钮的触发事件
    func pasteAction() {
        let boardStr = UIPasteboard.general.string ?? ""
        let textViewStr = textView.text  ?? ""
        //判断一下粘贴内容是否和textView内的内容相同
        if boardStr == textViewStr {
            lableView.isHidden = false
        }else{
            
            lableView.isHidden = true
            textView.text = boardStr
            //将粘贴按钮和获取淘口令按钮下移60的距离
            UIView.animate(withDuration: 0.4, animations: {anim->Void in
                self.PasteBtn.frame = CGRect(x: 10, y: HEIGHT/4 + 130, width: WIDTH-20, height: 50)
                self.getButton.frame = CGRect(x: 10, y: HEIGHT/4 + 200, width: WIDTH - 20, height: 50)
            })

        }
        
    }
    //中间lable的tap方法
    func tapCenterView() {
        let ShopingDetailView = ShopingDetailViewCtr()
        ShopingDetailView.goodDto = goodDto
        navigationController?.pushViewController(ShopingDetailView, animated: true)
    }
    //立即获取淘口令按钮的触发事件
    func getTaoKonAction() {
        statusList.removeAll()
        //检测有没有登录淘宝
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
                    
                    self.loadDataForCenterView()
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

    }

    //loadData
    func loadDataForCenterView() {
        
        let textViewStr = textView.text ?? ""
        if textViewStr.characters.count == 0 {
            showErrorText(status: "请粘贴内容")
            return
        }
        //网络请求 走获取商品列表的接口
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   1    固定值
         sign	       String	     	签名
         toPage        number           第N页
         perPageSize   number           每页显示N条数据
         q             String           查询关键字或产品URL
         cookie        String           登录淘宝后的cookie
         sortType      number           0:默认 7:佣金高到低 3:价格高到低 4:价格低到高 9:销量高到低	排序类型
         urlType       number           0:淘宝商品 1:高佣金商品 2:站内商品 链接类型标记
         dpyhq         number           1：拥有 其他：无	店铺优惠券
         */
        let searchUrl = searchAccount()
        
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let cookie = getStandCookie()
        let sign = GetSign()
        
        let searchDic = ["t":t,
                         "id":id,
                         "cellphone":cellphone,
                         "apt":1,
                         "sign":sign,
                         "toPage":1,
                         "perPageSize":20,
                         "q":textViewStr,
                         "cookie":cookie,
                         "sortType":0,
                         "urlType":0,
                         "dpyhq":0] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: searchUrl, parameters: searchDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            
            if code == 200 {
                let goodsEntitiesArr:[[String:Any]] = result?["goodsEntities"] as![[String:Any]]
                
                for goods in goodsEntitiesArr{
                    guard let GoodsEntitiesModel = JSONDeserializer<GoodsEntitiesDto>.deserializeFrom(dict: goods as NSDictionary?) else{
                        continue
                    }
                    self.statusList.append(GoodsEntitiesModel)
                }
                if self.statusList.count > 0{
                    self.goodDto = self.statusList[0]
                }
                let auctionUrl = self.goodDto.auctionUrl ?? ""
                self.lableView.isHidden = false
                self.centerLable.text = auctionUrl
              
                //将粘贴按钮和获取淘口令按钮下移60的距离
                UIView.animate(withDuration: 0.4, animations: {anim->Void in
                    
                    self.PasteBtn.frame = CGRect(x: 10, y: HEIGHT/4 + 130 + 100, width: WIDTH-20, height: 50)
                    self.getButton.frame = CGRect(x: 10, y: HEIGHT/4 + 200 + 100, width: WIDTH - 20, height: 50)
                })
                
            }else{
                self.showErrorHud(errorStr: message)
            }
        }) { (error) in
            
        }

    }
}
extension LinkViewController {
    func setupUI() {
        headerV.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT/4)
        view.addSubview(headerV)
        
        //添加textView
        textView.frame = CGRect(x: 10, y: HEIGHT/4 + 10, width: WIDTH-20, height: 100)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = GREEN.cgColor
        view.addSubview(textView)
        
        setupGetTaoKonBtn()
        setupSuccLable()
    }
    func setupGetTaoKonBtn() {
        
        PasteBtn.frame = CGRect(x: 10, y: HEIGHT/4 + 130, width: WIDTH-20, height: 50)
        PasteBtn.addTarget(self, action: #selector(pasteAction), for: .touchUpInside)
        view.addSubview(PasteBtn)
        
        
        getButton.frame = CGRect(x: 10, y: HEIGHT/4 + 200, width: WIDTH - 20, height: 50)
        getButton.colors = .init(button: GREEN, shadow: UIColor.darkGray)
        getButton.setTitle("立即获取淘口令", for: .normal)
        getButton.cornerRadius = 25
        getButton.shadowHeight = 2
        getButton.addTarget(self, action: #selector(getTaoKonAction), for: .touchUpInside)
        view.addSubview(getButton)
    }
    func setupSuccLable() {
        lableView.isHidden = true
        lableView.backgroundColor = RGB(r: 214, g: 215, b: 215)
        lableView.frame = CGRect(x: 10, y: HEIGHT/4 + 120, width: WIDTH-20, height: 100)
        //上边lable
        let topLable = UILabel(text: "下单地址为", fontSize: 14, Color: UIColor.black)
        topLable.textAlignment = .center
        topLable.frame = CGRect(x: 0, y: 0, width: WIDTH-20, height: 20)
        lableView.addSubview(topLable)
        //下边lable
        let bottomLable = UILabel(text: "点击查看详情", fontSize: 14, Color: UIColor.black)
        bottomLable.textAlignment = .center
        bottomLable.frame = CGRect(x: 0, y: 80, width: WIDTH-20, height: 20)
        lableView.addSubview(bottomLable)
        //中间的lable
        centerLable.frame = CGRect(x: 0, y: 40, width: WIDTH-20, height: 20)
        centerLable.textAlignment = .center
        centerLable.font = UIFont.systemFont(ofSize: 16)
        lableView.addSubview(centerLable)
        
        //给lableView添加手势方法
        lableView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapCenterView))
        lableView.addGestureRecognizer(tap)

        self.view.addSubview(lableView)
    }

}
