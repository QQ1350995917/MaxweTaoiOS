//
//  ApplicationViewController.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/30.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import SwiftyButton
class ApplicationViewController: BaseViewController {
    
    var textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGB(r: 247, g: 247, b: 247)
        title = "通用推广语"
        setupUI()
    }
    
    func saveContent() {
        let contentText = textView.text ?? ""
        if contentText.characters.count == 0 {
            showErrorText(status: "请填写通用推广语")
            return
            
        }
        /*
         ->body内容：
         t	           String	    	token
         id	           number	      	ID
         cellphone	   String	     	手机号码
         apt	       number	   1    固定值
         sign	       String	     	签名
         rhetoric	   String	    	0个到60个
         */
        let updateRhetoricUrl = updateRhetoricAccount()
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let sign = GetSign()
        
        let updateRhetoricDic = ["t":t,
                               "id":id,
                               "cellphone":cellphone,
                               "apt":1,
                               "sign":sign,
                               "rhetoric":contentText] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: updateRhetoricUrl, parameters: updateRhetoricDic, succeed: { (result) in
            
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            
            if code == 200 {
                self.showErrorText(status: "更新通用推广语成功")
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                self.showErrorHud(errorStr: message)
            }
            
        }) { (error) in
            
        }
    }
}
extension ApplicationViewController {
    func setupUI() {
        //创建textView
        setupTextView()
        setupSaveBtn()
    }
    func setupTextView() {
        textView.frame = CGRect(x: 10, y: navigationBar.bounds.height + 10, width: WIDTH-20, height: 200)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = RGB(r: 225, g: 195, b: 69).cgColor
        //需要事实获取一下user中的reson
        let mineUrl = mineAccount()
        let t = AppConfig.shareApp.userAccount?.t ?? ""
        let id = AppConfig.shareApp.userAccount?.id ?? 0
        let cellphone = AppConfig.shareApp.userAccount?.cellphone ?? ""
        let sign = GetSign()
        
        let mineDic = ["t":t,
                       "id":id,
                       "cellphone":cellphone,
                       "apt":1,
                       "sign":sign] as [String : Any]
        NetworkTool.shareInstance.request(requestType: .Post, url: mineUrl, parameters: mineDic, succeed: { (result) in
            //所有接口加一个判断逻辑
            let code:NSNumber = result?["code"] as! NSNumber
            let message: String = result?["message"] as! String
            if code == 200 {
                let user:[String : Any] = result?["user"] as! [String : Any]
                
                let MineDto = JSONDeserializer<MineDto>.deserializeFrom(dict: user as [String : Any]? as NSDictionary?)
                self.textView.text = MineDto?.rhetoric ?? ""
            }else{
                self.showErrorHud(errorStr: message)
            }
            
        }, failure: { (error) in
            
        })
        
        view.addSubview(textView)
    }
    func setupSaveBtn() {
        let saveButton = PressableButton()
        saveButton.frame = CGRect(x: 10, y: navigationBar.bounds.height + 240, width: WIDTH - 20, height: 50)
        saveButton.colors = .init(button: GREEN, shadow: UIColor.darkGray)
        saveButton.setTitle("保存", for: .normal)
        saveButton.cornerRadius = 25
        saveButton.shadowHeight = 2
        saveButton.addTarget(self, action: #selector(saveContent), for: .touchUpInside)
        view.addSubview(saveButton)
    }
}
