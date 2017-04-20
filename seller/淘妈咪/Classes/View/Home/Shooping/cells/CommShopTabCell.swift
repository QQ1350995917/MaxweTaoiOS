//
//  CommShopTabCell.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/26.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import SDWebImage
class CommShopTabCell: UITableViewCell {

    var GoodsModel:GoodsEntitiesDto? = GoodsEntitiesDto()
    
    @IBOutlet weak var IconImage: UIImageView!
    
    @IBOutlet weak var TorMImage: UIImageView!
    @IBOutlet weak var InfoL: UILabel!
    
    @IBOutlet weak var pirceL: UILabel!
    @IBOutlet weak var frontPL: UILabel!
    @IBOutlet weak var commissionL: UILabel!
    @IBOutlet weak var makeL: UILabel!
    @IBOutlet weak var salesL: UILabel!
    
    @IBOutlet weak var OfferL: UILabel!
    @IBOutlet weak var OfferPiceL: UILabel!
    //重写 model的setter getter方法 用于给属性赋值
    var model: GoodsEntitiesDto{

        set{
            //使用 GoodsModel 记录值
            GoodsModel = newValue
            let pictUrl = GoodsModel?.pictUrl ?? ""
            IconImage.sd_setImage(with: URL.init(string:pictUrl), placeholderImage: UIImage(named: "img-placeholder"))
            IconImage.sd_setImage(with: URL.init(string:pictUrl))
            
            let userType = GoodsModel?.userType ?? 0
            if userType == 0 {
                TorMImage.image = UIImage(named: "taobao.png")
            }else{
                TorMImage.image = UIImage(named: "tianmao.png")
            }
            
            let title = GoodsModel?.title ?? ""
            InfoL.text = title
            
            let zkPrice = GoodsModel?.zkPrice ?? 0.00
            pirceL.text = String(format: "¥%.1f",zkPrice)
            
            let reservePrice = GoodsModel?.reservePrice ?? 0.00
            frontPL.text = String(format: "¥%.1f",reservePrice)
        
            //取出佣金 取最大
            let tkRate = GoodsModel?.tkRate ?? 0.00
            let eventRate = GoodsModel?.eventRate ?? 0.00
            let tkSpecialCampaignIdRateMap = GoodsModel?.tkSpecialCampaignIdRateMap ?? ["0":"0"]
            //1>取出字典中的value
            let valueArr = Array(tkSpecialCampaignIdRateMap.values)
            //2>将valueArr中的所有string转换成CGFlot
            var FvalueArr = [Float]()
            for value in valueArr {
                let Fvalue = Float(value)
                FvalueArr.append(Fvalue!)
            }
            //3>取出数组中的最大值
        
            var arrMax:Float = 0.0
            if FvalueArr.count > 0 {
                arrMax = FvalueArr[0]
                for i in 0..<FvalueArr.count{
                    if FvalueArr[i] > arrMax{
                        arrMax = FvalueArr[i]
                    }
                }
            }
            //4>取出3个数中最大的值
            let max:Float = (eventRate > tkRate ? eventRate : tkRate) > arrMax ? (eventRate > tkRate ? eventRate : tkRate) : arrMax
            commissionL.text = String(format: "%.2f",max) + "%"

            //算一下赚
            let makeText = (max * zkPrice)/100
            makeL.text = String(format: "赚:%.2f元",makeText)
            
            let biz30day = GoodsModel?.biz30day ?? 0
            salesL.text = String(format: "月销:%ld",biz30day)

            //判断一下有没有优惠券
            let couponAmount = GoodsModel?.couponAmount ?? 0
            if couponAmount > 0 {
                OfferL.isHidden = false
                OfferPiceL.isHidden = false
                OfferPiceL.text = String(format: "%ld元",couponAmount)
            }else{
                OfferL.isHidden = true
                OfferPiceL.isHidden = true
            }
 

        }
        
        get{
            //返回 _成员变量
            return (self.GoodsModel)!
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        TorMImage.layer.cornerRadius = 5
        TorMImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
