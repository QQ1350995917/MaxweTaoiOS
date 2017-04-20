//
//  HomeBaseViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/26.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class HomeBaseViewController: BaseViewController {

    //定义一个tabView
    var tabView = UITableView()
    //上拉刷新的标记
    var isPull = false
    //定义一个遮盖导航栏的view
    var headerView = UIView()
    //用textFiled代替搜索框 可能没有
    var searchField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //隐藏掉自定义导航栏
        navigationBar.isHidden = true
        setUpUI()
    }

    //返回按钮的响应事件
    func popBack() {
        _ = navigationController?.popViewController(animated: true)
    }
}
extension HomeBaseViewController{
    func setUpUI() -> () {
        
        view.backgroundColor = RGB(r: 247, g: 247, b: 247)
        
        setUpHeaderView()
        setUpTabView()
        setupSearchVC()
    }
    
    /// headerView的设置
    func setUpHeaderView() -> () {
        headerView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 64)
        headerView.backgroundColor = RGB(r: 247, g: 247, b: 247)
        let backBtn = UIButton(frame: CGRect(x: 0, y: 30, width: 50, height: 30))
        backBtn.setImage(UIImage.init(named: "btn_back"), for: .normal)
        backBtn.setTitleColor(GREEN, for: .normal)
        backBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        headerView.addSubview(backBtn)
        view.addSubview(headerView)
    }
    
    /// tabView的设置
    func setUpTabView() -> () {
        
        //要先实例化 tabview 再去遵循代理
        tabView.frame = view.bounds
        //tabView.backgroundColor = UIColor.clear
        //设置内容缩进
        //tabView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        //设置代理 数据源方法-> 目的：让子类直接实现
        tabView.delegate = self
        tabView.dataSource = self
        
        
        view.insertSubview(tabView, belowSubview: headerView)
        
    }
    //搜索框的设置
    func setupSearchVC() {
        searchField = UITextField(frame: CGRect(x: 50, y: 24, width: WIDTH-60, height: 36))
        searchField?.backgroundColor = UIColor.white
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 36))
        let imageView = UIImageView(image: UIImage(named: "btn_search"))
        imageView.frame = CGRect(x: 10, y: 5, width: 25, height: 26)
        leftView.addSubview(imageView)
        searchField?.leftView = leftView
        searchField?.leftViewMode = .always
        searchField?.delegate = self
        headerView.addSubview(searchField!)
    }

}
// MARK: - UITextFieldDelegate
extension HomeBaseViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
// MARK: - UITableViewDelegate,UITableViewDataSource
extension HomeBaseViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
        
}
