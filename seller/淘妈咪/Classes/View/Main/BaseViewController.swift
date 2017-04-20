//
//  BaseViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    //自定义一个 navgationBar
    var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 64))
    
    //自定义 navgationItems
    var navItem = UINavigationItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        //取消自动缩进 如果隐藏了系统的导航栏 会自动缩进20个点
        automaticallyAdjustsScrollViewInsets = false
        setUpNavgation()
    }

    //计算型属性 重写 title didSet
    override var title: String?{
        
        didSet{
            navItem.title = title
        }
        
    }

    /// 导航条的设置
    private func setUpNavgation() -> () {
        
        //自定义的navItem 赋值给 navgationBar
        navigationBar.items = [navItem]
        //设置一下navgationBar 的渲染颜色
        navigationBar.barTintColor = GREEN
        //设置一下  navgationBar 的标题颜色
        //navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 30)]
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        view.addSubview(navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
