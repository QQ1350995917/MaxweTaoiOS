//
//  HighViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/26.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import ESPullToRefresh

//定义全局变量 cellId 尽量用private修饰，不会暴露在别的类中
private let cellId = "cellId"

class HighViewController: HomeBaseViewController {
    
    //一个全局的页数标记
    var toPage = 0
    //懒加载创建接收数据的数组
    lazy var statusList = [GoodsEntitiesDto]()
    //排序view
    let SortTypeView = UIView()
    //button数组
    var buttonArr = [UIButton]()
    //用于记录 价格是上升还是下降
    var IsUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //取一下 搜索框中的数据
        
        let searchText = searchField?.text ?? ""
        loadData(search: searchText, sortType: 0, discount: 0)
    }
    //MARK: -SortTypeView上按钮的响应事件
    func sortTypeButton(button:UIButton) {
        for btn in buttonArr {
            if button == btn {
                button.isSelected = true
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            }else{
                btn.isSelected = false
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            }
        }
        //取一下 搜索框中的数据
        let searchText = searchField?.text ?? ""
        self.statusList.removeAll()
        //取一下第一页的数据
        self.toPage = 0
        self.isPull = false
        //改变一下tableView的偏移量
        self.tabView.contentOffset = .zero
        if button.tag == 0 {
            //默认
            loadData(search: searchText, sortType: 0, discount: 0)
        }else if button.tag == 10{
            //佣金
            loadData(search: searchText, sortType: 7, discount: 0)
        }else if button.tag == 20{
            //价格是上升
            if IsUp {
                //高到底
                loadData(search: searchText, sortType: 3, discount: 0)
                button.setImage(UIImage.init(named: "jiageup_1"), for: .selected)
                IsUp = false
            }else{
                //低到高
                loadData(search: searchText, sortType: 4, discount: 0)
                button.setImage(UIImage.init(named: "jiagedown_1"), for: .selected)
                IsUp = true
            }
            
        }else if button.tag == 30{
            //销量
            loadData(search: searchText, sortType: 9, discount: 0)
        }else if button.tag == 40{
            //优惠券
            loadData(search: searchText, sortType: 0, discount: 1)
        }
    }
    /// 加载数据
    ///
    /// - Parameters:
    ///   - search: 搜索条件
    ///   - sortType: 排序类型
    ///   - discount: 是否有优惠券
    func loadData(search:String , sortType:Int = 0 , discount:Int = 0) {
        
        //判断刷新的逻辑
        if self.isPull{
            //上拉 toPage 加1
            toPage = toPage + 1
        }else{
            //下拉 toPage不变
            toPage = 0
        }
        
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   2    固定值
         sign	       String	     	签名
         toPage        number           第N页
         perPageSize   number           每页显示N条数据
         q             String           查询关键字或产品URL
         cookie        String           登录淘宝后的cookie
         sortType      number           0:默认 7:佣金高到低 3:价格高到低 4:价格低到高 9:销量高到低	排序类型
         urlType       number           0:淘宝商品 1:高佣金商品 2:站内商品 链接类型标记
         dpyhq         number           1：拥有 其他：无	店铺优惠券
         */
        let searchUrl = searchAccount()
        
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let cookie = getStandCookie()
        let sign = GetSign()
        
        let searchDic = ["t":t,
                         "id":id,
                         "cellphone":cellphone,
                         "apt":1,
                         "sign":sign,
                         "toPage":toPage,
                         "perPageSize":20,
                         "q":search,
                         "cookie":cookie,
                         "sortType":sortType,
                         "urlType":1,
                         "dpyhq":discount] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: searchUrl, parameters: searchDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            
            if code == 200 {
                let goodsEntitiesArr:[[String:Any]] = result?["goodsEntities"] as![[String:Any]]
                
                for goods in goodsEntitiesArr{
                    guard let GoodsEntitiesModel = JSONDeserializer<GoodsEntitiesDto>.deserializeFrom(dict: goods as NSDictionary?) else{
                        continue
                    }
                    self.statusList.append(GoodsEntitiesModel)
                }
                print(self.statusList.count)
                //恢复刷新标记
                self.isPull = false
                // 结束刷新
                self.tabView.es_stopPullToRefresh(completion: true)
                //刷新表格
                self.tabView.reloadData()
            }else{
                self.showErrorHud(errorStr: message)
            }
        }) { (error) in
            
        }
    }
}
// MARK: - textFiledDelegate
extension HighViewController{
    override func textFieldDidEndEditing(_ textField: UITextField) {
        //根据button数组 看一下哪个btn是高亮的 取出他的tag值
        var tag = 0
        for btn in buttonArr {
            if btn.isSelected {
                tag = btn.tag
            }
        }
        //根据按钮tag值判断搜索条件
        //取一下 搜索框中的数据
        let searchText = searchField?.text ?? ""
        self.statusList.removeAll()
        //取一下第一页的数据
        self.toPage = 0
        self.isPull = false
        //改变一下tableView的偏移量
        self.tabView.contentOffset = .zero
        
        if tag == 0 {
            //默认
            loadData(search: searchText, sortType: 0, discount: 0)
        }else if tag == 10{
            //佣金
            loadData(search: searchText, sortType: 7, discount: 0)
        }else if tag == 20{
            //价格是上升
            if IsUp {
                //高到底
                loadData(search: searchText, sortType: 3, discount: 0)
                IsUp = false
            }else{
                //低到高
                loadData(search: searchText, sortType: 4, discount: 0)
                
                IsUp = true
            }
            
        }else if tag == 30{
            //销量
            loadData(search: searchText, sortType: 9, discount: 0)
        }else if tag == 40{
            //优惠券
            loadData(search: searchText, sortType: 0, discount: 1)
        }
    }
}
// MARK: - 表格数据源方法，具体的数据源方法实现，不需要 super
extension HighViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1.取出cell
        let cell: CommShopTabCell = self.tabView.dequeueReusableCell(withIdentifier: cellId) as! CommShopTabCell
        //2.取数据 设置cell
        if indexPath.row >= statusList.count {
            return cell
        }
        
        let GoodsEntitiesModel = statusList[indexPath.row]
        cell.model = GoodsEntitiesModel
        //3.返回cell
        return cell
    }
    //cell点击方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row >= statusList.count {
            return
        }
        let goodModel = statusList[indexPath.row]
        let ShopingDetailView = ShopingDetailViewCtr()
        ShopingDetailView.goodDto = goodModel
        navigationController?.pushViewController(ShopingDetailView, animated: true)
    }
    //cell将要出现的代理方法
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //做无缝上拉刷新
        //1.取出最后一行 判断indexPath 是不是最后一行
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        //判断什么时候做上拉刷新 -> 如果是最后一行并且没有上拉刷新
        if row == (count - 1) && !isPull {
            isPull = true
            //开始刷新
            //根据button数组 看一下哪个btn是高亮的 取出他的tag值
            var tag = 0
            for btn in self.buttonArr {
                if btn.isSelected {
                    tag = btn.tag
                }
            }
            //根据按钮tag值判断搜索条件
            //取一下 搜索框中的数据
            let searchText = self.searchField?.text ?? ""
            if tag == 0 {
                //默认
                self.loadData(search: searchText, sortType: 0, discount: 0)
            }else if tag == 10{
                //佣金
                self.loadData(search: searchText, sortType: 7, discount: 0)
            }else if tag == 20{
                //价格是上升
                if self.IsUp {
                    //高到底
                    self.loadData(search: searchText, sortType: 3, discount: 0)
                    self.IsUp = false
                }else{
                    //低到高
                    self.loadData(search: searchText, sortType: 4, discount: 0)
                    self.IsUp = true
                }
            }else if tag == 30{
                //销量
                self.loadData(search: searchText, sortType: 9, discount: 0)
            }else if tag == 40{
                //优惠券
                self.loadData(search: searchText, sortType: 0, discount: 1)
            }
        }
        
    }
    
    
}
// MARK: - 设置界面
extension HighViewController {
    
    override func setUpUI() {
        super.setUpUI()
        setUpSortTypeView()
        
        //设置tabview的内容缩进
        tabView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height+40, 0, 0, 0)
        //去掉cell的横线
        tabView.separatorStyle = .none
        //设置 cell的高度
        tabView.rowHeight = 132
        //注册原型cell
        let cellNib = UINib(nibName: "CommShopTabCell", bundle: nil)
        tabView.register(cellNib, forCellReuseIdentifier: cellId)
        
        //添加下拉刷新
        _ = tabView.es_addPullToRefresh { esRefresh in
            
            self.toPage = 0
            self.isPull = false
            
            //根据button数组 看一下哪个btn是高亮的 取出他的tag值
            var tag = 0
            for btn in self.buttonArr {
                if btn.isSelected {
                    tag = btn.tag
                }
            }
            //根据按钮tag值判断搜索条件
            //取一下 搜索框中的数据
            let searchText = self.searchField?.text ?? ""
            self.statusList.removeAll()
            if tag == 0 {
                //默认
                self.loadData(search: searchText, sortType: 0, discount: 0)
            }else if tag == 10{
                //佣金
                self.loadData(search: searchText, sortType: 7, discount: 0)
            }else if tag == 20{
                //价格是上升
                if self.IsUp {
                    //高到底
                    self.loadData(search: searchText, sortType: 3, discount: 0)
                    self.IsUp = false
                }else{
                    //低到高
                    self.loadData(search: searchText, sortType: 4, discount: 0)
                    self.IsUp = true
                }
            }else if tag == 30{
                //销量
                self.loadData(search: searchText, sortType: 9, discount: 0)
            }else if tag == 40{
                //优惠券
                self.loadData(search: searchText, sortType: 0, discount: 1)
            }
        }
    }
    
    //设置 检索条件的几个按钮view
    func setUpSortTypeView() {
        let titleArr = ["默认","佣金","价格","销量","优惠券"]
        SortTypeView.frame = CGRect(x: 0, y: navigationBar.bounds.height, width: WIDTH, height: 40)
        SortTypeView.backgroundColor = RGB(r: 247, g: 247, b: 247)
        //创建按钮
        //计算宽度
        let w = WIDTH/5
        for i in 0..<5 {
            let button = UIButton(frame: CGRect(x: w * CGFloat(i), y: 0, width: w, height: 40))
            button.setTitle(titleArr[i], for: .normal)
            button.setTitleColor(RGB(r: 95, g: 95, b: 95), for: .normal)
            button.setTitleColor(RGB(r: 223, g: 86, b: 61), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.tag = i * 10
            if button.tag == 0 {
                button.isSelected = true
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            }
            
            if button.tag == 20 {
                button.setImage(UIImage.init(named: "jiagedown_1"), for: .selected)
            }
            button.addTarget(self, action: #selector(sortTypeButton(button:)), for: .touchUpInside)
            buttonArr.append(button)
            SortTypeView.addSubview(button)
        }
        view.addSubview(SortTypeView)
    }
}
