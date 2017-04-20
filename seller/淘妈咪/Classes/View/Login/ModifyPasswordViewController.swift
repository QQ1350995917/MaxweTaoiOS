//
//  ModifyPasswordViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/24.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import SwiftyButton
class ModifyPasswordViewController: BaseViewController {

    let placeArr = ["请输入账户密码",
                    "请输入新密码",
                    "请确认新密码",]
    //定义tabView
    var TabView: UITableView?

    //保存数据的字典
    var paramDict = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTabView()
        setupButton()
    }
    //保存修改按钮的监听方法
    func saveNewPassWord() {
        //获取字典中的信息
        let oldPassW = paramDict["old"] ?? ""
        let newPassW = paramDict["new"] ?? ""
        let againPassW = paramDict["again"] ?? ""
        //定义错误信息
        //错误信息
        var errorStr = ""
        if oldPassW.characters.count == 0{
            errorStr = "请输入原密码"
        }else if newPassW.characters.count == 0{
            errorStr = "请输入新密码"
        }else if againPassW.characters.count == 0{
            errorStr = "请确认新密码"
        }else if newPassW != againPassW{
            errorStr = "两次输入的密码不相同"
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
         apt	       number	   2    固定值
         sign	       String	     	签名
         authenticatePassword	String		6到12位密码,原密码
         password	   String	    	6到12位密码,新密码
         */
        let passwordUrl = passwordAccount()
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""

        let passwordDic = ["t":t,
                           "id":id,
                           "cellphone":cellphone,
                           "apt":1,
                           "sign":GetSign(),
                           "authenticatePassword":oldPassW,
                           "password":newPassW] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: passwordUrl, parameters: passwordDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            
            if code == 200 {
                //取到退出通知 重新登录
                let notification = NotificationCenter.default
                notification.post(name: NSNotification.Name(LoginSuccess), object: "LoginOut")
                self.showErrorText(status: "重置密码成功")
            }else{
                self.showErrorHud(errorStr: message)
            }
        }) { (error) in
            
        }
        
    }
    //键盘里输入发生变化的监听方法
    func tableViewValueChanged(field: UITextField) {
        if field.tag == 0 {
            paramDict["old"] = field.text
        }else if field.tag == 100 {
            paramDict["new"] = field.text
        }else if field.tag == 200 {
            paramDict["again"] = field.text
        }
    }
}

// MARK: - 界面设置
extension ModifyPasswordViewController{
    
    func setupUI() {
        title = "修改密码"
    }
    //设置 TabView
    func setupTabView() {
        TabView = UITableView(frame: view.bounds, style: .plain)
        //设置代理
        TabView?.delegate = self
        TabView?.dataSource = self
        //取消滑动
        TabView?.isScrollEnabled = false
        //设置内容缩进
        TabView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height+10, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        //设置 cell的高度
        TabView?.rowHeight = 60
        //去掉 横线
        TabView?.separatorStyle = .none
        view.insertSubview(TabView!, belowSubview: navigationBar)
    }
    //设置添加按钮为 tableView的footer
    func setupButton() {
        let quitButton = PressableButton()
        quitButton.frame = CGRect(x: 10, y: 30, width: WIDTH - 20, height: 50)
        quitButton.colors = .init(button: GREEN, shadow: UIColor.darkGray)
        quitButton.setTitle("保存修改", for: .normal)
        quitButton.cornerRadius = 25
        quitButton.shadowHeight = 3
        //添加监听方法
        quitButton.addTarget(self, action: #selector(saveNewPassWord), for: .touchUpInside)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 100))
        footerView.addSubview(quitButton)
        TabView?.tableFooterView = footerView
        
    }
}
// MARK: - UITableViewDelegate,UITableViewDataSource
extension ModifyPasswordViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    //设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=Bundle.main.loadNibNamed("RegisterTabCell", owner: self, options: nil)?.first as! RegisterTabCell
        
        cell.textField.placeholder = placeArr[indexPath.row]
        cell.textField.isSecureTextEntry = true
        cell.textField.tag = indexPath.row * 100
        cell.textField.addTarget(self, action: #selector(tableViewValueChanged(field:)), for: .editingChanged)
        
        //取消cell的点击效果
        cell.selectionStyle = .none
        
        return cell
    }
}
