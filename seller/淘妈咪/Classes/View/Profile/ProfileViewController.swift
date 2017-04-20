//
//  ProfileViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import SwiftyButton
class ProfileViewController: BaseViewController {
    
    let titleArr = ["登录淘宝",
                    "推广位",
                    "申请佣金理由",
                    "通用推广语",
                    "推广赚积分",
                    "修改密码",
                    "关于我们"]
    //定义tabView
    var TabView: UITableView?
    //定义上边的视图
    let headerV = HeaderView()
    override func viewDidLoad() {
        super.viewDidLoad()

        //隐藏掉导航栏
        navigationBar.isHidden = true
        setupUI()
        setupTabView()
        setupButton()
    }
    
    //MARK: -cell中按钮的点击方法
    func cellButtonAction(button:UIButton) {
        print("按钮的tag值为：\(button.tag)")
        if button.tag == 0 {
            //检测是否需要淘宝登录
            testTaobaoLogin(completion: { (cookie) in
                let data:[String: Any] = cookie["data"] as! [String: Any]
                
                guard let noLogin = data["noLogin"] else{
                    self.showErrorText(status: "您已经登录")
                    return
                }
                let noLoginStr = String(describing: noLogin)
                if noLoginStr == "1"{
                    let taobaoWeb = TBLoginWebViewController()
                    self.present(taobaoWeb, animated: true, completion: { 
                        
                    })
                }
            })
            
        }else if button.tag == 100{
            //检测是否需要淘宝登录
            testTaobaoLogin(completion: { (cookie) in
                let data:[String: Any] = cookie["data"] as! [String: Any]
                
                guard let noLogin = data["noLogin"] else{
                    //如果验证成功
                    let brandsView = BrandsViewController()
                    self.navigationController?.pushViewController(brandsView, animated: true)
                    return
                }
                let noLoginStr = String(describing: noLogin)
                if noLoginStr == "1"{
                    let taobaoWeb = TBLoginWebViewController()
                    self.present(taobaoWeb, animated: true, completion: {
                        
                    })
                }
            })
        }else if button.tag == 200{
            //申请佣金理由
            let PromotionlanguageView = PromotionlanguageViewController()
            self.navigationController?.pushViewController(PromotionlanguageView, animated: true)
        }else if button.tag == 300{
            //通用推广语
            let ApplicationView = ApplicationViewController()
            self.navigationController?.pushViewController(ApplicationView, animated: true)

        }else if button.tag == 400{
            //推广赚积分
            let IntegralHtml = IntegralViewController()
            present(IntegralHtml, animated: true, completion: { 
                
            })

        }else if button.tag == 500{
            //修改密码
            let modifyVC = ModifyPasswordViewController()
            self.navigationController?.pushViewController(modifyVC, animated: true)
        }else if button.tag == 600{
            //关于我们
            let HtmlWeb = HTMLViewController()
            HtmlWeb.htmlUrl = "/webapp/widgets/static/aboutus-user.html"
            HtmlWeb.htmlTitle = "关于我们"
            present(HtmlWeb, animated: true, completion: { 
                
            })
        }
    }
    
    //MARK: -退出按钮的 监听方法
    func exitApp() {
        
        //取到退出通知
        let notification = NotificationCenter.default
        notification.post(name: NSNotification.Name(LoginSuccess), object: "LoginOut")

    }
}


// MARK: - 界面设置
extension ProfileViewController{
    func setupUI() {
        headerV.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT/4)
        view.addSubview(headerV)

    }
    //设置 TabView
    func setupTabView() {
        TabView = UITableView(frame: view.bounds, style: .plain)
        //设置代理
        TabView?.delegate = self
        TabView?.dataSource = self
        //取消滑动
        //TabView?.isScrollEnabled = false
        //设置内容缩进
        TabView?.contentInset = UIEdgeInsetsMake(HEIGHT/4+40, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        //设置 cell的高度
        TabView?.rowHeight = 60
        //去掉 横线
        TabView?.separatorStyle = .none
        view.insertSubview(TabView!, belowSubview: headerV)
    }
    //设置添加按钮为 tableView的footer
    func setupButton() {
        let quitButton = PressableButton()
        quitButton.frame = CGRect(x: 10, y: 30, width: WIDTH - 20, height: 50)
        quitButton.colors = .init(button: GREEN, shadow: UIColor.darkGray)
        quitButton.setTitle("退出", for: .normal)
        quitButton.cornerRadius = 5
        quitButton.shadowHeight = 3
        quitButton.addTarget(self, action: #selector(exitApp), for: .touchUpInside)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 100))
        footerView.addSubview(quitButton)
        TabView?.tableFooterView = footerView
        
    }

}
// MARK: - UITableViewDelegate,UITableViewDataSource
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    //设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTabCell()
        //取消cell的点击效果
        cell.selectionStyle = .none

        cell.ActionBtn.setTitle(titleArr[indexPath.row], for: .normal)
        cell.ActionBtn.tag = indexPath.row * 100
        cell.ActionBtn.addTarget(self, action: #selector(cellButtonAction(button:)), for: .touchUpInside)

        return cell
    }
}

