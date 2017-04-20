//
//  UIButton+Extansions.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

extension UIButton{
    
    
    
    /// 创建文本按钮
    ///
    /// - Parameters:
    ///   - title: 标题文字UIColor.darkGray    ///   - fontSize: 字体大小
    ///   - normalColor: 默认颜色
    ///   - highlightedColor: 高亮颜色
    ///   - backgroundImageName : 背景图像名称
    convenience init(title: String , fontSize: CGFloat = 16 , normalColor: UIColor , highlightedColor: UIColor) {
        
        self.init()
        
        self.setTitle(title, for: .normal)
        
        self.setTitleColor(normalColor, for: .normal)
        self.setTitleColor(highlightedColor, for: .highlighted)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
                
        self.sizeToFit()
    }

    
    /// 创建通用保存按钮
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - title: title description
    ///   - fontSize: fontSize description
    ///   - titleColor: titleColor description
    ///   - backColor: backColor description
    ///   - layer: layer description
    convenience init(frame:CGRect ,title: String ,fontSize: CGFloat = 18 ,titleColor: UIColor ,backColor: UIColor, layer: CGFloat = 25) {
        
        self.init()
        
        self.frame = frame
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(RGB(r: 173, g: 226, b: 233), for: .highlighted)
        self.backgroundColor = backColor
        self.layer.cornerRadius = layer

        //self.sizeToFit()
    }
    
    /// Description
    ///
    /// - Parameters:
    ///   - title: title description
    ///   - fontSize: fontSize description
    ///   - textColor: textColor description
    ///   - backColor: backColor description
    convenience init(title: String , fontSize: CGFloat = 16 , textColor: UIColor , backColor: UIColor) {
        
        self.init()
        
        self.setTitle(title, for: .normal)
        
        self.setTitleColor(textColor, for: .normal)
        self.setTitleColor(UIColor.darkGray, for: .highlighted)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.backgroundColor = backColor
        self.sizeToFit()
    }

}
