//
//  IntegralViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/4/9.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import JavaScriptCore

class IntegralViewController: UIViewController {

    
    let webView = UIWebView()
    var headView = UIView()
    var jsContext:JSContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupHeader()
        setupWebView()
    }

    //返回按钮的监听方法
    func dismisCtr() {
        self.dismiss(animated: true) {
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - 界面设置
extension IntegralViewController {
    
    func setupUI() {
        
    }
    func setupHeader() {
        //headerView
        headView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 64))
        headView.backgroundColor = GREEN
        let backButton = UIButton(title: "返回", fontSize: 16, normalColor: UIColor.white, highlightedColor: GREEN)
        backButton.frame = CGRect(x: 0, y: 30, width: 80, height: 30)
        backButton.addTarget(self, action: #selector(dismisCtr), for: .touchUpInside)
        headView.addSubview(backButton)
        view.addSubview(headView)
    }
    func setupWebView() {
        //webView
        webView.frame = CGRect(x: 0, y: 64, width: WIDTH, height: HEIGHT-64)
        
        let urlString = String(format: "%@/user/referenceInfo?id=%ld",DOMAIN,(AppConfig.shareApp.userAccount?.id)!)
        let url = NSURL(string: urlString)
        //添加代理
        webView.delegate = self
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
        
        view.addSubview(webView)
        
    }
    
}
//这边是直接用模型做的比较方便也比较严谨利于扩展 直接调用就不介绍了
//JSExport要遵从这个协议才能使自己的api对外界开放
@objc protocol JavaScriptSwiftDelegate:JSExport
{
    
    //定义协议 这边可以传参 也可以传字典啥的 可以定义多个方法
    //传多个参数用字典比较合适 单个参数直接传
    func payResult(dict: [String:AnyObject])
    
    
}
//创建模型 在模型中实现代理
@objc class JSModelSwift:NSObject,JavaScriptSwiftDelegate
{
    
    weak var jsContext:JSContext?
    
    //定义模型方法
    func payResult(dict: [String:AnyObject])
    {
        //打印获取的值 这边讲一下 原理是这样的模型后面会注册到js中这样js就可以调用模型及其方法，一般要配合后台人员传参所以这边的参数是已经有值得可以直接打印出来
        
        
        //向js方法传值这边实现传值是Swift调用js
        //这边是从swift端向js端传数据 所以要在js端定义一个function来接收
        //        let jsParamsFunc = self.jsContext?.objectForKeyedSubscript("jsParamsFunc")
        //        let dict = NSDictionary(dictionary: ["from":"订单","payCode":9000,"payInfo":"seccuess"])
        //        jsParamsFunc?.callWithArguments([dict])
        
        //js端的代码
        
        //var jsParamFunc = function(argument) {
        //这边是讲html上的一个元素用字典的一个value赋值
        // document.getElementById('jsParamFuncSpan').innerHTML
        // = argument['payCode'];
    }
    
    
}
extension IntegralViewController: UIWebViewDelegate{
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //创建js中的上下文环境
        let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext")as?JSContext
        //创建模型
        let model = JSModelSwift()
        model.jsContext = context
        self.jsContext = context
        
        // 这一步是将JSModel这个模型注入到JS中，在JS就可以通过JSModel调用我们公暴露的方法了。从而实现从js端向app端传值了
        //附一段传值事件
        //<input type="button"value="Call ObjC func with JSON and ObjC call js func to pass //args."onclick="JSModel.payResult({'payCode': 100, 'payInfo': 'faile', 'from': 'Xcode'})">
        //这边数据是后台的事 后台只要在onclick事件后面添加JSModel.payResult({'payCode': 100, 'payInfo': 'faile', 'from': 'Xcode'})方法并且传数据 Xcode就可以获取数据了
        //
        self.jsContext?.setObject(model, forKeyedSubscript:"JSModel" as (NSCopying & NSObjectProtocol)!)
        
        
        //捕捉异常可以不写
        self.jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception @", exception as Any)
        }
    }
    
}
