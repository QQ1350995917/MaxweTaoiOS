//
//  HTMLViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/26.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class HTMLViewController: UIViewController {

    var htmlUrl = ""
    var htmlTitle = ""
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
        
    }
}
extension HTMLViewController {
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
        let titleLable = UILabel(text: htmlTitle, Color: UIColor.white)
        titleLable.frame = CGRect(x: 100, y: 30, width: WIDTH-200, height: 30)
        titleLable.textAlignment = .center
        titleLable.font = UIFont.systemFont(ofSize: 20)
        headView.addSubview(titleLable)
        view.addSubview(headView)
    }
    func setupWebView() {
        //webView
        webView.frame = CGRect(x: 0, y: 64, width: WIDTH, height: HEIGHT-64)
        
        let url = NSURL(string:DOMAIN + htmlUrl)
        //添加代理
        webView.delegate = self
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
        
        view.addSubview(webView)
        
    }
}
// MARK: - UIWebViewDelegate
extension HTMLViewController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //获取当前页面的URL
        
        if let url = request.url,
           let titleStr = webView.stringByEvaluatingJavaScript(from: "document.title") {
            let urlStr = String(describing: url)
            
            print("当前页面的URL为:\(urlStr)")
            print("当前页面的title为:\(titleStr)")
            
        }
        return true
    }
}
