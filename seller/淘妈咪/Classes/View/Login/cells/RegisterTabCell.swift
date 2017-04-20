//
//  RegisterTabCell.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/23.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class RegisterTabCell: UITableViewCell {

    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
