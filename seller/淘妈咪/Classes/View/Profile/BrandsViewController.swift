//
//  BrandsViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/28.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
private let leftId = "leftId"
private let rightId = "rightId"

class BrandsViewController: BaseViewController {

    //定义一个字典用于存储id信息 和存放到沙盒下
    var IDDic = ["siteId":"","id":""] as [String : Any]
    //用于判断 键盘弹出 是否移动view
    var viewUp: Bool = false

    //检验是否需要创建导购位View
    //var brandsView = BrandsView()
    //创建两个tabView
    var leftTab = UITableView()
    var rightTab = UITableView()
    //创建两个 盛装数据的数组
    var leftStatus = [brandsDto]()
    var rightStatus = [adZonesDto]()
    //创建推广位 view
    var brandsView = Bundle.main.loadNibNamed("CreatebrandsView", owner: nil, options: nil)?.first as! CreatebrandsView

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "推广位"
        
        loadData()
    }
    
    //创建导购位按钮的功能
    func createBrands() {
        //检测本地cookie是否过期
        //1> 有没有 cookie 需不需要登录淘宝
        testTaobaoLogin(completion: { (cookie) in
            let data:[String: Any] = cookie["data"] as! [String: Any]
            
            guard let noLogin = data["noLogin"] else{
               
                self.httpCreateBrands()
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
    //创建导购推广位时走的网络请求
    func httpCreateBrands() {
        let weChat = self.brandsView.weixinText.text ?? ""
        
        if weChat.characters.count == 0 {
            self.showErrorText(status: "请先输入微信号")
            return
        }

        //创建导购位
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   1    固定值
         sign	       String	     	签名
         cookie	       String	     	登录淘宝后的cookie
         guideName	   String	        淘妈咪导购推广	 导购推广位名称
         adZoneName	   String	        淘妈咪导购推广位	推广位的名称
         weChat	       String	     	微信号
         */
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let cookie = getCookie(url: TAOBAOURL!)
        let sign = GetSign()
        
        let createBrandsURL = createBrandsAccount()
        let createBrandsDic = ["t":t,
                               "id":id,
                               "cellphone":cellphone,
                               "apt":1,
                               "sign":sign,
                               "cookie":cookie,
                               "weChat":weChat,
                               "guideName":"淘妈咪导购推广",
                               "adZoneName":"淘妈咪微信导购推广位"] as [String : Any]
        
        NetworkTool.shareInstance.request(requestType: .Post, url: createBrandsURL, parameters: createBrandsDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            if code == 200 {
                self.hideAlertViewOnKeyWindow()
                self.loadData()
            }else{
                self.showErrorHud(errorStr: message)
            }
        }) { (error) in
            
        }
        

    }
    //加载数据
    func loadData() {
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   1    固定值
         sign	       String	     	签名
         cookie	       String	     	登录淘宝后的cookie
         */
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let cookie = getStandCookie()
        let sign = GetSign()

        let brandsUrl = brandsAccount()
        let brandsDic = ["t":t,
                         "id":id,
                         "cellphone":cellphone,
                         "apt":1,
                         "sign":sign,
                         "cookie":cookie] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: brandsUrl, parameters: brandsDic, succeed: { (result) in
            //取出code 判断一下
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            if code == 404{
                self.brandsView.frame = CGRect(x: 30, y: (HEIGHT-180)/2, width: WIDTH-60, height: 180)
                //为按钮添加点击响应方法
                self.brandsView.createB.addTarget(self, action: #selector(self.createBrands), for: .touchUpInside)
                //添加textField的代理方法
                self.brandsView.weixinText.delegate = self

                self.showAlertViewOnKeyWindow(alertView: self.brandsView)
            }else if code == 200{
                //将数据添加到数组中
                let brandsArr:[[String:Any]] = result?["brands"] as![[String:Any]]
                for brand in brandsArr {
                    guard let brandsModel = JSONDeserializer<brandsDto>.deserializeFrom(dict: brand as NSDictionary?) else{
                        continue
                    }
                    self.leftStatus.append(brandsModel)
                }
                self.leftTab.reloadData()
            }else{
                self.showErrorHud(errorStr: message)
            }

        }) { (error) in
            
        }
    }

}
// MARK: - 设置界面
extension BrandsViewController {
    
    func setupUI() {
        view.backgroundColor = RGB(r: 247, g: 247, b: 247)
        //创建左右lable
        let titleArr = ["导购推广","导购推广位"]
        for i in 0..<2 {
            let textLab = UILabel(text: titleArr[i], Color: RGB(r: 128, g: 128, b: 128))
            textLab.backgroundColor = RGB(r: 247, g: 247, b: 247)
            textLab.frame = CGRect(x: WIDTH/2 * CGFloat(i), y: navigationBar.bounds.height, width: WIDTH/2, height: 30)
            textLab.font = UIFont.systemFont(ofSize: 18)
            textLab.textAlignment = .center
            view.addSubview(textLab)
        }
        //创建中间的竖线
        let lineView = UIView(frame: CGRect(x: WIDTH/2 - 0.5, y: navigationBar.bounds.height + 30, width: 1, height: HEIGHT - 20 - navigationBar.bounds.height))
        lineView.backgroundColor = RGB(r: 180, g: 180, b: 180)
        view.addSubview(lineView)
        
        //注册左右两个原型cell
        //注册原型cell
        leftTab.register(UITableViewCell.self, forCellReuseIdentifier: leftId)
        rightTab.register(UITableViewCell.self, forCellReuseIdentifier: rightId)

        setupTabView()
    }
    
    func setupTabView() {
        //left
        leftTab.frame = CGRect(x: 0, y: 0, width: WIDTH/2, height: HEIGHT)
        leftTab.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height+30, 0, 0, 0)
        leftTab.delegate = self
        leftTab.dataSource = self
        leftTab.separatorStyle = .none
        view.insertSubview(leftTab, belowSubview: navigationBar)
        //right
        rightTab.frame = CGRect(x: WIDTH/2, y: 0, width: WIDTH/2, height: HEIGHT)
        rightTab.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height+30, 0, 0, 0)
        rightTab.delegate = self
        rightTab.dataSource = self
        rightTab.separatorStyle = .none
        view.insertSubview(rightTab, belowSubview: navigationBar)
    }
}
// MARK: - UITableViewDelegate,UITableViewDataSource
extension BrandsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTab {
            return leftStatus.count
        }else if tableView == rightTab{
            return rightStatus.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //取出cell
        if tableView == leftTab {
            let leftCell = leftTab.dequeueReusableCell(withIdentifier: leftId, for: indexPath)
            let brandsModel = leftStatus[indexPath.row]
            leftCell.textLabel?.text = brandsModel.name
            leftCell.textLabel?.textColor = RGB(r: 140, g: 140, b: 140)
            leftCell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return leftCell
        }else{
            let rightCell = rightTab.dequeueReusableCell(withIdentifier: rightId, for: indexPath)
            let adZonesModel = rightStatus[indexPath.row]
        
            rightCell.textLabel?.text = adZonesModel.name
            rightCell.textLabel?.textColor = RGB(r: 140, g: 140, b: 140)
            rightCell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            return rightCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == leftTab {
            //取出数据 赋值新数组
            rightStatus.removeAll()
            let brandsModel = leftStatus[indexPath.row]
            guard let adZonesArr = brandsModel.adZones else {
                return
            }
            rightStatus += adZonesArr
            self.rightTab.reloadData()
        }else if tableView == rightTab{
            let adZonesModel = rightStatus[indexPath.row]
            //取出沙盒
            let sandBox = UserDefaults.standard
            //将沙盒内的id字典清空
            sandBox.removeObject(forKey: "BrandsId")
            //取出cell对应信息 存放到字典
            IDDic["siteId"] = adZonesModel.siteId
            IDDic["id"] = adZonesModel.id
            //将当前id字典信息以字典形式暂存到沙盒中
            sandBox.setValue(IDDic, forKey: "BrandsId")

            let cell = rightTab.cellForRow(at: indexPath)
            let cellArr = rightTab.visibleCells
            for alterCell in cellArr {
                if alterCell == cell {
                    alterCell.imageView?.image = UIImage(named: "chenggong")
                }else{
                    alterCell.imageView?.image = UIImage(named: "")
                }
            }
        }
    }
}
// MARK: - UITextFieldDelegate
extension BrandsViewController:UITextFieldDelegate{
    //键盘相关
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        
        if viewUp{
            return
        }
        //        let subMitB = activeView.viewWithTag(100) as! UIButton
        //        var roolHeight = 362.5 - (HEIGHT - 64 - subMitB.frame.origin.y)
        //        print("相差高度  \(roolHeight)")
        //        if roolHeight <= 0 {
        //            roolHeight = 0
        //        }
        UIView.animate(withDuration: 0.4, animations: {anim->Void in
            self.viewUp = true
            self.brandsView.frame = CGRect(x: 30, y: (HEIGHT-180)/2-50, width: WIDTH-60, height: 180)
        })
        
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField){
        if viewUp {
            //            let subMitB = activeView.viewWithTag(100) as! UIButton
            //            var roolHeight = 362.5 - (HEIGHT - 64 - subMitB.frame.origin.y)
            //            print("相差高度  \(roolHeight)")
            //            if roolHeight <= 0 {
            //                roolHeight = 0
            //            }
            UIView.animate(withDuration: 0.4, animations: {anim->Void in
                self.viewUp = false
                self.brandsView.frame = CGRect(x: 30, y: (HEIGHT-180)/2, width: WIDTH-60, height: 180)
                
            })
        }
    }
}
