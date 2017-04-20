//
//  UILable+Extansions.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String , fontSize: CGFloat = 16 , Color: UIColor) {
        
        self.init()

        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.textColor = Color

    }

}
