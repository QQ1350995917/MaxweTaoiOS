//
//  ProfileTabCell.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/24.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import SwiftyButton
class ProfileTabCell: UITableViewCell {

    var ActionBtn: FlatButton = FlatButton()
    //代码创建视图需要 加上
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        ActionBtn.frame = CGRect(x: 10, y: 5, width: WIDTH-20, height: 50)
        ActionBtn.layer.borderColor = GREEN.cgColor
        ActionBtn.layer.borderWidth = 1.0
        ActionBtn.layer.cornerRadius = 25
        ActionBtn.color = .white
        ActionBtn.highlightedColor = GREEN
        ActionBtn.cornerRadius = 25
        ActionBtn.setTitleColor(GREEN, for: .normal)
        ActionBtn.setTitleColor(UIColor.white, for: .highlighted)
        
        self.addSubview(ActionBtn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
