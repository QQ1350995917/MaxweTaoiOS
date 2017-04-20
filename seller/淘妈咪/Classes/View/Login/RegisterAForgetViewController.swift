//
//  RegisterAForgetViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/23.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class RegisterAForgetViewController: BaseViewController {

    //数组用来给textField的place赋值
    let placeArr = ["请输入手机号码",
                    "请输入图形验证码",
                    "请输入手机验证码",
                    "请输入6-12位密码",
                    "请确认密码"]
    //用来记录是注册界面还是忘记密码界面
    var isRorF = true
    //用来记录保存按钮的文字
    var buttonText = ""
    //定义一个 tabView
    var TabView: UITableView?
    //保存数据的字典
    var paramDict = [String:String]()
    //定义一个图片验证码view
    let AuthcodeView:LocalAuthcodeView = LocalAuthcodeView.init()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTabView()
        setupButton()
    }
    //codetab的点击方法
    func tapCodeBtn() {
        //获取填写的手机号
        let phoneStr = paramDict["phone"]
        let url = existAccount()
        let dic = ["cellphone":phoneStr]
        //判断一下 如果是忘记密码场景 不需要验证手机号是否可用
        if isRorF {
            NetworkTool.shareInstance.request(requestType: .Post, url: url, parameters: dic, succeed: { (result) in
                //手机号可以注册 获取验证码
                self.sendCode(phone: phoneStr!)
            }) { (error) in
                //self.hideLoading()
            }
            
        }else{
            sendCode(phone: phoneStr!)
        }
    }
    //提取出 发送验证码接口方法
    func sendCode(phone: String) {
        let codeUrl = smsCodeAccount()
        let codeDic = ["cellphone":phone]
        NetworkTool.shareInstance.request(requestType: .Post, url: codeUrl, parameters: codeDic, succeed: { (result) in
            
            
        }, failure: { (error) in
            
        })

    }
    // MARK: - 校验手机号格式是否正确
//    func isCorrectTelNumber(num:String)->Bool{
//        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
//        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
//        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
//        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
//        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
//        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
//        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
//        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
//        if ((regextestmobile.evaluate(with: num) == true)
//            || (regextestcm.evaluate(with: num)  == true)
//            || (regextestct.evaluate(with: num) == true)
//            || (regextestcu.evaluate(with: num) == true)){
//            return true
//        }else{
//            return false
//        }
//    }

    //注册或者 重置密码按钮的点击方法
    func registerAction() -> (){
        //获取一下本地图片验证码
        let code = AuthcodeView.authCodeStr.lowercased
        //获取添加的图片验证码
        let imageCodeStr = paramDict["imageCode"] ?? ""
        //转换成小写
        let str = imageCodeStr.lowercased()
        //获取字典中的信息
        let phoneStr = paramDict["phone"] ?? ""
        let messageCodeStr = paramDict["messageCode"] ?? ""
        let passWordStr = paramDict["passWord"] ?? ""
        let confirmStr = paramDict ["confirm"] ?? ""
        //判断填写信息
        var errorStr = ""
        
        if phoneStr.characters.count==0{
            errorStr="请填写手机号码"
        }else if code != str{
            errorStr="图片验证码填写错误"
            AuthcodeView.getAuthcode()
            AuthcodeView.setNeedsDisplay()
        }else if imageCodeStr.characters.count == 0{
            errorStr="请填写图片验证码"
        }else if messageCodeStr.characters.count == 0{
            errorStr="请填写短信验证码"
        }else if passWordStr.characters.count == 0{
            errorStr="请填写密码"
        }else if confirmStr.characters.count == 0{
            errorStr="请填写确认密码"
        }else if (passWordStr.characters.count)<6 || (passWordStr.characters.count)>12{
            errorStr = "密码位数填写错误"
        }else if passWordStr != confirmStr{
            errorStr = "两次输入密码不相同"
        }
        
        if errorStr.isEmpty==false {
            self.showErrorText(status: errorStr)
            return
        }
        
        //网络请求
        let registerUrl = signupAccount() //注册
        let lostUrl = lostAccount() //忘记密码
        /*
         ->body内容：
         apt	       number      1	固定值
         cellphone	   String	     	手机号码
         smsCode	   String       	手机短信验证码号码
         password	   String	     	6到12位密码
         */
        let registerDic = ["apt":1,
                           "cellphone":phoneStr,
                           "smsCode":messageCodeStr,
                           "password":passWordStr] as [String : Any]
        //判断一下是哪种场景
        if isRorF {
            NetworkTool.shareInstance.request(requestType: .Post, url: registerUrl, parameters: registerDic, succeed: { (result) in
                //所有接口加一个判断逻辑
                let code:NSNumber = result?["code"] as! NSNumber
                let message: String = result?["message"] as! String
                
                if code == 200 {
                    self.showErrorText(status: "注册成功")
                    sleep(UInt32(0.5))
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorHud(errorStr: message)
                }
            }) { (error) in
                
            }
            
        }else{
            NetworkTool.shareInstance.request(requestType: .Post, url: lostUrl, parameters: registerDic, succeed: { (result) in
                //所有接口加一个判断逻辑
                let code:NSNumber = result?["code"] as! NSNumber
                let message: String = result?["message"] as! String
                
                if code == 200 {
                    self.showErrorText(status: "重置密码成功")
                    sleep(UInt32(0.5))
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorHud(errorStr: message)
                }
            }) { (error) in
                
            }
        }
    }
    //根据textField的变化将数据添加到字典中
    func tableViewValueChanged(field:UITextField){
        if field.tag == 0 {
            paramDict["phone"] = field.text
        }else if field.tag == 100 {
            paramDict["imageCode"] = field.text
        }else if field.tag == 200 {
            paramDict["messageCode"] = field.text
        }else if field.tag == 300 {
            paramDict["passWord"] = field.text
        }else if field.tag == 400 {
            paramDict["confirm"] = field.text
        }
    }

}

// MARK: - 界面相关设置
extension RegisterAForgetViewController{
    
    func setupUI() {
        if isRorF {
            title = "注册"
            buttonText = "注册"
        }else{
            title = "忘记密码"
            buttonText = "重置密码"
        }

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
        TabView?.rowHeight = 55
        //去掉 横线
        TabView?.separatorStyle = .none
        view.insertSubview(TabView!, belowSubview: navigationBar)
    }
    //设置添加按钮为 tableView的footer
    func setupButton() {
        let registerB = UIButton(
            frame: CGRect(x: 20, y: 30, width: WIDTH - 40, height: 50),
            title: buttonText,
            titleColor: UIColor.white,
            backColor: GREEN)
        registerB.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 100))
        footerView.addSubview(registerB)
        TabView?.tableFooterView = footerView
    
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension RegisterAForgetViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    //设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=Bundle.main.loadNibNamed("RegisterTabCell", owner: self, options: nil)?.first as! RegisterTabCell
        
        cell.textField.placeholder = placeArr[indexPath.row]
        cell.textField.tag = indexPath.row * 100
        cell.textField.addTarget(self, action: #selector(tableViewValueChanged(field:)), for: .editingChanged)

        //取消cell的点击效果
        cell.selectionStyle = .none
        //每一个cell的相关设置
        if indexPath.row==0 {
            //手机号
            cell.textField.keyboardType = .numberPad
            let phoneStr = paramDict["phone"]
            if phoneStr?.isEmpty==false{
                cell.textField.text = phoneStr
            }
        }else if indexPath.row==1{
            //图形验证码
            let imageCodeStr = paramDict["imageCode"]
            if imageCodeStr?.isEmpty==false{
                cell.textField.text = imageCodeStr
            }
            //添加图形验证码
            AuthcodeView.frame = CGRect(x: WIDTH-125, y: 7, width: 100, height: 41)
            cell.addSubview(AuthcodeView)
            //AuthcodeView.getAuthcode()
            
        }else if indexPath.row==2{
            //短信验证码
            cell.textField.keyboardType = .numberPad
            let messageCodeStr = paramDict["messageCode"]
            if messageCodeStr?.isEmpty==false{
                cell.textField.text = messageCodeStr
            }
            //添加获取短信验证码按钮(添加手势)
            let codeBtn = UIButton(frame: CGRect(x: WIDTH-125, y: 7, width: 100, height: 41))
            codeBtn.setTitle("点击获取验证码", for: .normal)
            codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            codeBtn.setTitleColor(RGB(r: 137, g: 137, b: 137), for: .normal)
            codeBtn.setTitleColor(UIColor.darkGray, for: .highlighted)
            codeBtn.backgroundColor = RGB(r: 192, g: 192, b: 192)
            codeBtn.addTarget(self, action: #selector(tapCodeBtn), for: .touchUpInside)
            cell.addSubview(codeBtn)

        }else if indexPath.row==3{
            //密码
            let passWordStr = paramDict["passWord"]
            if passWordStr?.isEmpty==false{
                cell.textField.text = passWordStr
            }
        }else if indexPath.row==4{
            //确认密码
            let confirmStr = paramDict["confirm"]
            if confirmStr?.isEmpty==false{
                cell.textField.text = confirmStr
            }
        }
        return cell
    }
}
