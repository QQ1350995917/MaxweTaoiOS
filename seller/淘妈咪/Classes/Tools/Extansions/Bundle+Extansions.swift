//
//  Bundle+Extansions.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/21.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import Foundation

extension Bundle{
    
    var nameSpce: String{
        
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
