//
//  AppDelegate.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LaunchScreenDelegate {

    var window: UIWindow?

    //Share appkey:1c9fb35283e10   f297109612ddec5f95986ac01a355e4f
    //WeChat KEY:wxbb25593e790df366  QQ KEY:1105924933

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */

        ShareSDK.registerApp("1c9fb35283e10",
                             activePlatforms :
            [
                SSDKPlatformType.typeWechat.rawValue,
                SSDKPlatformType.typeQQ.rawValue,
            ],
                             // onImport 里的代码,需要连接社交平台SDK时触发
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wxbb25593e790df366",
                                             appSecret: "f297109612ddec5f95986ac01a355e4f")
                    
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: "1105924933",
                                         appKey: "f297109612ddec5f95986ac01a355e4f",
                                         authType: SSDKAuthTypeBoth)
                default:
                    break
                }
        })
        
        
        
        
        // 用户登录退出通知
        let loginNotification = NotificationCenter.default
        loginNotification.addObserver(self, selector: #selector(initRootViewCtr(_:)), name: NSNotification.Name(rawValue: ExitLoginOut), object: nil)
        loginNotification.addObserver(self, selector: #selector(initRootViewCtr(_:)), name: NSNotification.Name(rawValue: LoginSuccess), object: nil)

        IQKeyboardManager.sharedManager().enable = true
        
        window = UIWindow()
        
        window?.backgroundColor = UIColor.white

        //做一下启动视图
        let launchCtr = LaunchScreenViewCtr()
        
        launchCtr.delegate = self
        
        self.window?.rootViewController = launchCtr
        
        window?.makeKeyAndVisible()
        
        return true
    }
    //启动视图的代理
    func launchScreenSuccess(){
        self.initRootViewCtr(nil)
    }

    //启动 Tabbar
    func initRootViewCtr(_ notification:Notification?) -> () {
        //取一下沙盒
        let sandBox = UserDefaults.standard
        //看一下通知 是登录还是退出 如果是退出，走退出接口，
        if notification != nil {
            
            let notiName:String? = notification?.object as! String?
            if notiName == "LoginOut" {
                //网络请求
                /*
                 ->body内容：
                 t	           String	    	token
                 id	           number	      	ID
                 cellphone	   String	     	手机号码
                 apt	       number	   1    固定值
                 sign	       String	     	签名
                 */
                let signoutUrl = signoutAccount()
                let t = AppConfig.shareApp.userAccount?.t ?? ""
                let id = AppConfig.shareApp.userAccount?.id ?? 0
                let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
                let sign = GetSign()

                let signoutDic = ["t":t,
                                   "id":id,
                                   "cellphone":cellphone,
                                   "apt":1,
                                   "sign":sign] as [String : Any]
                NetworkTool.shareInstance.request(requestType: .Post, url: signoutUrl, parameters: signoutDic, succeed: { (result) in
                    //弹出退出成功的提示框
                    //所有接口加一个判断逻辑
                    let code:NSNumber = result?["code"] as! NSNumber
                    let message: String = result?["message"] as! String
                    if code == 200 {
                        SVProgressHUD.showInfo(withStatus: "退出成功")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        let alView = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                        alView.show()
                    }


                }, failure: { (error) in
                    
                })
                
                //将沙盒内的字典清空
                sandBox.removeObject(forKey: "UserInfo")
                //将沙盒内的cookie清空
                sandBox.removeObject(forKey: "cookie")
            }
        }
        //获取一下沙盒内容
        let userInfo = sandBox.value(forKey: "UserInfo")
        print("沙盒内容为：\(userInfo)")
        //判读一下沙盒内容是否为空 是跳到登录界面还是 主界面
        if userInfo == nil {
            let nav = NavigationControllerViewController(rootViewController: LoginViewController())
            window?.rootViewController = nav
        }else{
            //将沙盒路径中的内容 付给单例 方便以后调取
            let userModel = userInfo as! Dictionary<String,Any>
            AppConfig.shareApp.userAccount = JSONDeserializer<UserModel>.deserializeFrom(dict: userModel as NSDictionary?)

            let tabbar = MainTabBarViewController()
            window?.rootViewController = tabbar
        }
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

