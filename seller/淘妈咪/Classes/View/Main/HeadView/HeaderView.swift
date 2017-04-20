//
//  HeaderView.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/24.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //私有控件
    ///图像视图
    private lazy var iconView: UIImageView = UIImageView(image: UIImage.init(named: "tao_anim_header@2x"))

    func setupUI() {
        backgroundColor = GREEN
        addSubview(iconView)
        //2.取消 autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //3.自动布局
        addConstraint(NSLayoutConstraint(
            item: iconView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: iconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0))

    }
}
