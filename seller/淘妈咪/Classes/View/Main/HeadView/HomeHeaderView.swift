//
//  HomeHeaderView.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/24.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    @IBOutlet weak var shopingB: UIButton!
    @IBOutlet weak var insideB: UIButton!
    @IBOutlet weak var highB: UIButton!
    
    override func awakeFromNib() {
        shopingB.titleLabel?.numberOfLines = 2
        insideB.titleLabel?.numberOfLines = 2
        highB.titleLabel?.numberOfLines = 2
    }
}
