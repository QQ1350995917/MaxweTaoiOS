//
//  LoginViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var account: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginB: UIButton!
    
    @IBOutlet weak var registerB: UIButton!
    
    @IBOutlet weak var forgetB: UIButton!
    
    //懒加载 左边视图
    private lazy var accoutImage: UIImageView = UIImageView(image: UIImage.init(named: "username"))
    private lazy var passwordImage: UIImageView = UIImageView(image: UIImage.init(named: "pasword"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //隐藏掉导航栏
        navigationBar.isHidden = true
        setupUI()
        
    }

    //设置界面
    func setupUI() {
        //设置账户有没有初始值
//        let sandBox = UserDefaults.standard
//        let cellphone:String = sandBox.value(forKey: "cellphone") as! String
//        account.text = cellphone as String?

        //设置 左边视图
        accoutImage.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        account.addSubview(accoutImage)
        passwordImage.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        password.addSubview(passwordImage)
        //设置圆角弧度和外边颜色
        account.keyboardType = .numberPad
        account.layer.borderColor = GREEN.cgColor
        account.layer.borderWidth = 1
        account.layer.cornerRadius = 25
        
        password.isSecureTextEntry = true
        password.layer.borderColor = GREEN.cgColor
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 25

        //设置按钮的元角度
        loginB.layer.cornerRadius = 25

    }
    //注册
    @IBAction func registerAction(_ sender: Any) {
        let registerVC = RegisterAForgetViewController()
        registerVC.isRorF = true
        navigationController?.pushViewController(registerVC, animated: true)
    }
    //忘记密码
    @IBAction func forgetPassword(_ sender: Any) {
        let registerVC = RegisterAForgetViewController()
        registerVC.isRorF = false
        navigationController?.pushViewController(registerVC, animated: true)

    }
    //登录
    @IBAction func loginApp(_ sender: Any) {
        //取出textField中的信息
        let accO = account.text ?? ""
        let passW = password.text ?? ""
        
        //错误信息
        var errorStr = ""
        if accO.characters.count == 0 {
            errorStr = "请输入账号"
        }else if passW.characters.count == 0{
            errorStr = "请输入密码"
        }
        if errorStr.isEmpty==false {
            self.showErrorText(status: errorStr)
            return
        }
        //网络请求
        let signinUrl = signinAccount()
        /*
         apt	       number      1	固定值
         cellphone	   String	     	手机号码
         password      String           6到12位密码
         */

        let signinDic = ["apt":1,
                         "cellphone":accO,
                         "password":passW] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: signinUrl, parameters: signinDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            
            if code == 200 {
                let token:[String : Any] = result?["token"] as! [String : Any]
                let userModel = JSONDeserializer<UserModel>.deserializeFrom(dict: token as NSDictionary?)
                AppConfig.shareApp.userAccount = userModel
                
                //取到沙盒 将当前用户信息以字典形式暂存到沙盒中
                let sandBox = UserDefaults.standard
                sandBox.setValue(token, forKey: "UserInfo")
                 //取到登录通知
                let notification = NotificationCenter.default
                notification.post(name: NSNotification.Name(LoginSuccess), object: "LoginIn")
                self.showErrorText(status: "登录成功")

            }else{
                self.showErrorHud(errorStr: message)
            }
        }) { (error) in
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

