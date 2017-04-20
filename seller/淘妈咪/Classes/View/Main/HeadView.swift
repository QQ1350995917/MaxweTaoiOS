//
//  HeadView.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

//左右按钮的代理方法
@objc protocol HeadViewDelegate:NSObjectProtocol{
    
    func responseLeftAction()
    
    
    @objc optional func responseRightAction()
    
    
}

class HeadView: UIView {

    var delegate: HeadViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //懒加载 视图
    //左边按钮
    lazy var leftButton: UIButton = UIButton(title: "返回", normalColor: UIColor.white, highlightedColor: UIColor.darkGray)
    //右边按钮
    lazy var rightButton: UIButton = UIButton(title: "", normalColor: UIColor.white, highlightedColor: UIColor.darkGray)

    //中间title
    lazy var title: UILabel = UILabel(text: "注册", Color: UIColor.white)

    func setupUI() {
        
        self.backgroundColor = GREEN
        addSubview(leftButton)
        addSubview(title)
        //取消 autoresizing
        for v in subviews{
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //自动布局
        //leftButton
        leftButton.addTarget(self, action: #selector(leftButtonAction(_:)), for: .touchUpInside)
        addConstraint(NSLayoutConstraint(
            item: leftButton,
            attribute: .left,
            relatedBy: .equal,
            toItem: self,
            attribute: .left,
            multiplier: 1.0,
            constant: 10))
        addConstraint(NSLayoutConstraint(
            item: leftButton,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 10))
        addConstraint(NSLayoutConstraint(
            item: leftButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 80))

        //rightButton
        rightButton.addTarget(self, action: #selector(rightButtonAction(_:)), for: .touchUpInside)
        addConstraint(NSLayoutConstraint(
            item: rightButton,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1.0,
            constant: 10))
        addConstraint(NSLayoutConstraint(
            item: leftButton,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 10))
        addConstraint(NSLayoutConstraint(
            item: rightButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 80))
        //title
        //视图字典
        let viewDic = ["leftButton":leftButton,
                       "rightButton":rightButton,
                       "title":title] as [String : Any]
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[leftButton]-0-[title]-0-[rightButton]",
            options: [],
            metrics: nil,
            views: viewDic))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDic))

    }
    
    //左右按钮的监听方法
    func leftButtonAction(_ button: UIButton) {
        delegate?.responseLeftAction()
    }
    
    func rightButtonAction(_ button: UIButton) {
        delegate?.responseRightAction!()
    }
}
