//
//  TBLoginWebViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/25.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class TBLoginWebViewController: UIViewController {

    let webView = UIWebView()
    var headView = UIView()
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
extension TBLoginWebViewController {
    
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
        
        let url = NSURL(string: "https://login.m.taobao.com/login.htm?redirectURL=http://www.alimama.com/index.htm?is_login=1&loginFrom=wap_alimama")
        //添加代理
        webView.delegate = self
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
        
        view.addSubview(webView)

    }
    
}
// MARK: - UIWebViewDelegate
extension TBLoginWebViewController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //登录成功的URL
        let LoginUrl = "http://www.alimama.com/index.htm"
        //获取当前页面的URL
        if let url = request.url {
            let urlStr = String(describing: url)
            
            print("当前页面的URL为:\(urlStr)")
            //判断两个URL是否相等
            if urlStr == LoginUrl {
                let cookieStr = getCookie(url: TAOBAOURL!)
                //将cookieStr存储到沙盒中，用于下次不用重复登录淘宝
                //取出沙盒
                let sandBox = UserDefaults.standard
                //将沙盒内的cookie清空
                sandBox.removeObject(forKey: "cookie")
                sandBox.setValue(cookieStr, forKey: "cookie")

                showErrorText(status: "登录成功")
                dismisCtr()
            }

        }
        return true
    }
}
