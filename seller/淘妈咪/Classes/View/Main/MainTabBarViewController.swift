//
//  MainTabBarViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()
        setupChildcontrollers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MainTabBarViewController{
    
    //设置 tabbar 的渲染颜色
    func setUpTabBar() ->() {
        
        //去掉 tababr 上面的黑线
        
        //1.设置tababr的风格
        tabBar.barStyle = .black
        
        //2.设置 tabbar 的渲染颜色
        tabBar.barTintColor = GREEN
        
    }

    //添加自控制器
    func setupChildcontrollers() -> () {
        
        let array = [["clsName":"HomeViewController","imageName":"index","title":"首页"],
                     ["clsName":"LinkViewController","imageName":"link","title":"转链工具"],
                     ["clsName":"ProfileViewController","imageName":"mine","title":"我的"]]
        
        //创建一个 装有控制器的数组
        var arrayM = [UIViewController]()
        for dict in array{
            
            let vc =  setupController(dict: dict)
            arrayM.append(vc)
        }
        
        viewControllers = arrayM

    }
    
    //创建控制器
    func setupController( dict: [String: String]) -> UIViewController {
        
        //取得字典信息
        guard let clsName = dict["clsName"],
              let imageName = dict["imageName"],
              let title = dict["title"],
              let cls = NSClassFromString(Bundle.main.nameSpce + "." + clsName) as? UIViewController.Type
        else {
            return UIViewController()
        }

        //取得控制器
        let vc = cls.init()
        
        //3.添加图像 加 图像渲染
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName + "_normal")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_active")?.withRenderingMode(.alwaysOriginal)

        //更改 tababr的字体颜色
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .normal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:RGB(r: 236, g: 217, b: 0)], for: .highlighted)
        
        let nav = NavigationControllerViewController(rootViewController: vc)
        
        return nav
    }
}
