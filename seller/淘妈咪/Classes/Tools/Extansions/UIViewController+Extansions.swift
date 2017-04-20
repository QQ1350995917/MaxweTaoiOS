//
//  UIViewController+Extansions.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/25.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

private let Ext_ContentView = UIView()
private let Ext_GrayView = UIView()

extension UIViewController{
    // MARK: - 弹出选取框
    func showAlertViewOnKeyWindow(alertView:UIView){
        self.view.endEditing(true)
        hideAlertViewOnKeyWindow()
        let keyWindow = UIApplication.shared.keyWindow
        let bounds = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        Ext_ContentView.frame=bounds
        Ext_GrayView.frame=bounds
        Ext_GrayView.backgroundColor=UIColor.black
        Ext_GrayView.alpha=0.6
        Ext_ContentView.addSubview(Ext_GrayView)
        Ext_ContentView.addSubview(alertView)
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideAlertViewOnKeyWindow))
//        Ext_ContentView.addGestureRecognizer(tap)
        keyWindow?.addSubview(Ext_ContentView)
    }
    
    //隐藏选取框
    func hideAlertViewOnKeyWindow(){
        for view in Ext_ContentView.subviews {
            view.removeFromSuperview()
        }
        Ext_GrayView.removeFromSuperview()
        Ext_ContentView.removeFromSuperview()
    }
    
    //错误提示框
    func showErrorText(status: String){
        SVProgressHUD.showInfo(withStatus: status)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SVProgressHUD.dismiss()
        }
    }
    func showErrorHud(errorStr:String){
        let alView = UIAlertView(title: "提示", message: errorStr, delegate: nil, cancelButtonTitle: "确定")
        alView.show()
    }


}
