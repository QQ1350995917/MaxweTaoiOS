//
//  HomeViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    //用于判断 键盘弹出 是否移动view
    var viewUp: Bool = false
    //titleArr
    let titleArr = ["新手教程",
                    "用户必看",
                    "功能介绍"]
    //headerView
    var headerView = Bundle.main.loadNibNamed("HomeHeaderView", owner: nil, options: nil)?.first as! HomeHeaderView
    //认证View
    var activeView = Bundle.main.loadNibNamed("ActiveView", owner: nil, options: nil)?.first as! ActiveView

    var TabView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //隐藏导航栏
        navigationBar.isHidden = true
        
        setupUI()
        setupTabView()
        //检验 用户是否激活
        testActivate()
        
    }
    //MARK: -检验用户是否激活 获取用户信息看一下 actCode是否为空
    func testActivate() {
        //网络请求
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   1    固定值
         sign	       String	     	签名
         */
        let mineUrl = mineAccount()
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let sign = GetSign()

        let mineDic = ["t":t,
                       "id":id,
                       "cellphone":cellphone,
                       "apt":1,
                       "sign":sign] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: mineUrl, parameters: mineDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            if code == 200 {
                let user:[String : Any] = result?["user"] as! [String : Any]
                
                let MineDto = JSONDeserializer<MineDto>.deserializeFrom(dict: user as [String : Any]? as NSDictionary?)
                
                //print(MineDto?.status)
                //判断一下 actCode是否为空 为空 弹出认证view 不为空 什么也不做
                if MineDto?.actCode == nil || MineDto?.actCode?.characters.count == 0{
                    self.activeView.frame = CGRect(x: 50, y: (HEIGHT-250)/2, width: WIDTH-100, height: 250)
                    //为3个 按钮添加点击响应方法
                    self.activeView.activeB.addTarget(self, action: #selector(self.activeAction), for: .touchUpInside)
                    self.activeView.exitB.addTarget(self, action: #selector(self.exitAction), for: .touchUpInside)
                    self.activeView.laterB.addTarget(self, action: #selector(self.laterAction), for: .touchUpInside)
                    
                    //添加textField的代理方法
                    self.activeView.aCodeText.delegate = self
                    self.activeView.passText.delegate = self
                    
                    self.showAlertViewOnKeyWindow(alertView:self.activeView)
                }
            }else{
                self.showErrorHud(errorStr: message)
            }
            
        }, failure: { (error) in
            
        })
        
    }

    //MARK: -headerView中4个按钮的点击方法
    ///淘宝商品按钮
    func shopingBAcion() {
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
                    let shopingView = ShopingViewController()
                    self.navigationController?.pushViewController(shopingView, animated: true)
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
    /// 站内商品按钮
    func insideBAcion() {
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
                    let insideView = InsideViewController()
                    self.navigationController?.pushViewController(insideView, animated: true)
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
    /// 高拥商品按钮
    func highBAcion() {
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
                    let highView = HighViewController()
                    self.navigationController?.pushViewController(highView, animated: true)
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

    //MARK: -activeView中3个按钮的响应事件
    func activeAction() {
        
        //获取activeView中的textFiled中的信息
        let actCodeText = activeView.aCodeText.text ?? ""
        let authenticatePasswordText = activeView.passText.text ?? ""
        //错误信息
        var errorStr = ""
        if actCodeText.characters.count == 0{
            errorStr = "请输入激活码"
        }else if authenticatePasswordText.characters.count == 0{
            errorStr = "请输入密码"
        }
        if errorStr.isEmpty==false {
            self.showErrorText(status: errorStr)
            return
        }

        //网络请求
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   1    固定值
         sign	       String	     	签名
         actCode       String           八位激活码
         authenticatePassword   String   敏感操作，输入密码
         */
        let activeUrl = activeAccount()
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let sign = GetSign()
        
        let activeDic = ["t":t,
                       "id":id,
                       "cellphone":cellphone,
                       "apt":1,
                       "sign":sign,
                       "actCode":actCodeText,
                       "authenticatePassword":authenticatePasswordText] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: activeUrl, parameters: activeDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            
            if code == 200 {
                //如果认证成功
                self.showErrorText(status: "激活成功")
                self.hideAlertViewOnKeyWindow()
            }else{
                self.showErrorHud(errorStr: message)
            }
        }) { (error) in
            
        }

    }
    func exitAction() {
        //退出
        //取到退出通知 重新登录
        let notification = NotificationCenter.default
        notification.post(name: NSNotification.Name(LoginSuccess), object: "LoginOut")
        
    }
    func laterAction() {
        //稍后认证
        //取到退出通知 重新登录
        let notification = NotificationCenter.default
        notification.post(name: NSNotification.Name(LoginSuccess), object: "LoginOut")

    }
    //MARK: -tableView中三个按钮的响应事件
    func cellButtonAction(button:UIButton) {
        if button.tag == 0 {
            let HtmlWeb = HTMLViewController()
            HtmlWeb.htmlTitle = "新手教程"
            HtmlWeb.htmlUrl = "/webapp/widgets/static/tutorial-user.html"
            present(HtmlWeb, animated: true, completion: { 
                
            })
        }else if button.tag == 100{
            let HtmlWeb = HTMLViewController()
            HtmlWeb.htmlTitle = "用户必看"
            HtmlWeb.htmlUrl = "/webapp/widgets/static/readme-user.html"
            present(HtmlWeb, animated: true, completion: {
                
            })
        }else if button.tag == 200{
            let HtmlWeb = HTMLViewController()
            HtmlWeb.htmlTitle = "功能介绍"
            HtmlWeb.htmlUrl = "/webapp/widgets/static/introduction-user.html"
            present(HtmlWeb, animated: true, completion: {
                
            })
        }
    }
}
// MARK: - 界面相关设置
extension HomeViewController {
    
    func setupUI() {
        headerView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 400)
        //view.addSubview(headerView)
        
        //headerView中4个按钮添加相应事件
        headerView.shopingB.addTarget(self, action: #selector(shopingBAcion), for: .touchUpInside)
        headerView.insideB.addTarget(self, action: #selector(insideBAcion), for: .touchUpInside)
        headerView.highB.addTarget(self, action: #selector(highBAcion), for: .touchUpInside)
    }
    
    //设置 TabView
    func setupTabView() {
        TabView = UITableView(frame: view.bounds, style: .plain)
        //设置代理
        TabView?.delegate = self
        TabView?.dataSource = self
        //取消滑动
        //TabView?.isScrollEnabled = false
        //设置内容缩进
        TabView?.contentInset = UIEdgeInsetsMake(0, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        //设置 cell的高度
        TabView?.rowHeight = 60
        //去掉 横线
        TabView?.separatorStyle = .none
        TabView?.tableHeaderView = headerView
        view.insertSubview(TabView!, belowSubview: headerView)
    }
    
}
// MARK: - UITableViewDelegate,UITableViewDataSource
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    //设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTabCell()
        //取消cell的点击效果
        cell.selectionStyle = .none
        
        cell.ActionBtn.setTitle(titleArr[indexPath.row], for: .normal)
        cell.ActionBtn.tag = indexPath.row * 100
        cell.ActionBtn.addTarget(self, action: #selector(cellButtonAction(button:)), for: .touchUpInside)
        
        return cell
    }
}
// MARK: - UITextFieldDelegate
extension HomeViewController:UITextFieldDelegate{
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
            self.activeView.frame = CGRect(x: 50, y: (HEIGHT-250)/2-80, width: WIDTH-100, height: 250)
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
                self.activeView.frame = CGRect(x: 50, y: (HEIGHT-250)/2, width: WIDTH-100, height: 250)
                
            })
        }
    }
}
