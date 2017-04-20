//
//  AppConfig.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit


let ExitLoginOut = "UserExitLoginNotification"      // 用户退出登录通知
let LoginSuccess = "UserLoginSuccessNotification"   // 用户登录成功通知

let WIDTH = UIScreen.main.bounds.size.width         //屏幕宽
let HEIGHT = UIScreen.main.bounds.size.height       //屏幕高
let GREEN = RGB(r: 139, g: 213, b: 224)  //绿色

let TAOBAOURL = URL(string: "http://ad.alimama.com/cps/shopkeeper/loginMessage.json")
// 根据RGB创建颜色
func RGB(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}
//这里获取 请求参数 sign的加密 value值
func GetSign() -> String{
    //1.获取加密内容
    let timeInterval = (NSDate().timeIntervalSince1970)*1000
    let timeStamp = Int(timeInterval)
    
    guard let id = AppConfig.shareApp.userAccount?.id,
        let cellphone = AppConfig.shareApp.userAccount?.cellphone else {
            return ""
    }
    let str = "\(id)-\(timeStamp)-\(cellphone)"
    //2.获取key
    let keyStr = getKey(cellphone: cellphone)
    //3.对加密内容进行base编码
    let utf8EncodeData = str.data(using: String.Encoding.utf8, allowLossyConversion: true)
    let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
    //4.AES加密
    guard let aesStr = NSData.aes128Encrypt(base64String, key: keyStr) else {
        return ""
    }
    return aesStr
}
//获取key
func getKey(cellphone: String) -> String {
    //用户手机号码 + 反转的用户手机号码 进行从第二位开始截取16位
    
    var reversedStr = ""
    for c in cellphone.characters.reversed() {
        reversedStr.append(c)
    }
    var oneStr = ""
    oneStr = cellphone + reversedStr
    
    let nsStr = oneStr as NSString
    let outStr = nsStr.substring(with: NSMakeRange(1, 16))
    let needStr = outStr as String
    
    return needStr
}

//单列 用于在App内部随时调用 用户信息
class AppConfig: NSObject {
    static let shareApp = AppConfig()
    //    var userAccount:Dictionary<String, Any>?
    var userAccount:UserModel?
    private override init() {
    }
}
//用于检测 是否登录了淘宝 异步检测
func testTaobaoLogin(completion:@escaping (_ List: [String: Any]) -> ()) -> () {
    
    DispatchQueue.global().async {
        
        //(1）设置请求路径
        let url = TAOBAOURL
        //(2)获取本地cookie
        let cookieStr = getStandCookie()
        //(3) 创建请求对象
        let request = NSMutableURLRequest.init(url: url!)
        request.timeoutInterval = 5.0 //设置请求超时为5秒
        request.httpMethod = "POST"  //设置请求方法
        request.addValue(cookieStr, forHTTPHeaderField: "Cookie")//请求头
        //(4) 发送请求
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue:OperationQueue()) { (res, data, error)in
            //转换成字典
            let dictionary:[String: Any] = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
            //主线程回调
            DispatchQueue.main.async {
                //回调 执行闭包
                completion(dictionary)
            }
        }
    }
}

//获取本地的沙盒路径内的cookie 以后接口都要用本地cookie但是在按钮点击事件之前，要检测cookie
func getStandCookie() -> String{
    var cookieStr = ""
    let sandBox = UserDefaults.standard
    let cookie = sandBox.value(forKey: "cookie")
    if cookie == nil {
        cookieStr = ""
    }else{
        cookieStr = cookie as! String
    }
    return cookieStr
}
//获取登录淘宝成功后内置浏览器中的cookie
func getCookie(url: URL) -> String{
    var cookieStr = ""
    let cookies = HTTPCookieStorage.shared.cookies(for: url)
    var cookieDic = HTTPCookie.requestHeaderFields(with: cookies!)
    //取出cookie中 字典的值
    cookieStr = cookieDic["Cookie"] ?? ""
    return cookieStr
}
