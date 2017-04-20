//
//  NavigationControllerViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class NavigationControllerViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏掉系统的 navgationBar
        navigationBar.isHidden = true
    }

    //重写父类的push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //子页面个数
        if childViewControllers.count > 0 {
            //隐藏掉tabbar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器的类型，取出基类控制器的 navItem
            if let vc = viewController as? BaseViewController {
                
                let backBtn = UIButton(title: "返回", fontSize: 16, normalColor: UIColor.white, highlightedColor: RGB(r: 173, g: 226, b: 233))
                backBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)
                let leftBtn = UIBarButtonItem(customView:backBtn)
                
                vc.navItem.leftBarButtonItem = leftBtn
            }

        }
        
        
        super.pushViewController(viewController, animated: true)
    }
    
    //返回上一级 界面的方法
    @objc private func popBack() -> () {
        popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
