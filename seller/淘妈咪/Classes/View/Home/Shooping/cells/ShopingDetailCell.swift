//
//  ShopingDetailCell.swift
//  淘妈咪
//
//  Created by msk on 2017/3/28.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

class ShopingDetailCell: UITableViewCell {

    @IBOutlet weak var percentLab: UILabel!
    @IBOutlet weak var earnLab: UILabel!
    @IBOutlet weak var tipLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var oldPriceLab: UILabel!
    
    @IBOutlet weak var couponsView: UIView!
    
    @IBOutlet weak var couponsLab: UILabel!
    @IBOutlet weak var couponsPriceLab: UILabel!
    
    @IBOutlet weak var sellNumLab: UILabel!
    @IBOutlet weak var couponsNumLab: UILabel!
    @IBOutlet weak var couponsEndTimeLab: UILabel!
    
    var goodDto:GoodsEntitiesDto!
    
    //重写 model的setter getter方法 用于给属性赋值
    var model: GoodsEntitiesDto{
        
        set{
            //使用 goodDto 记录值
            goodDto = newValue
            //取出佣金 取最大
            let tkRate = goodDto?.tkRate ?? 0.00
            let eventRate = goodDto?.eventRate ?? 0.00
            let tkSpecialCampaignIdRateMap = goodDto?.tkSpecialCampaignIdRateMap ?? ["0":"0"]
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
            percentLab.text = String(format: "%.2f", max)+"%"
            tipLab.text = String(format: "可一键申请最高佣金：%.2f", max)+"%"

            let zkPrice = goodDto?.zkPrice ?? 0.00
            priceLab.text = String(format: "¥%.1f",zkPrice)

            //算一下赚
            let makeText = (max * zkPrice)/100
            earnLab.text = String(format: "赚:%.2f元",makeText)

            let reservePrice = goodDto?.reservePrice ?? 0.00
            let attr = NSMutableAttributedString(string: "￥\(reservePrice)")
            attr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(0, attr.length))
            oldPriceLab.attributedText = attr

            //判断一下有没有优惠券
            let couponAmount = goodDto?.couponAmount ?? 0
            let couponInfo = goodDto?.couponInfo ?? ""
            if couponAmount > 0 {
                couponsView.isHidden = false
                couponsPriceLab.text = String(format: "%ld元 %@", couponAmount,couponInfo)
            }

            let biz30day = goodDto?.biz30day ?? 0
            sellNumLab.text = String(format: "月销:%ld",biz30day)
            
            let couponTotalCount = goodDto?.couponTotalCount ?? 0
            let couponLeftCount = goodDto?.couponLeftCount ?? 0
            //算一下已经领取了多少优惠券
            let getedCount = couponTotalCount - couponLeftCount
            couponsNumLab.text = String(format: "优惠券总数量:%ld，已领取:%ld，剩余:%ld", couponTotalCount,getedCount,couponLeftCount)
            
            let couponEffectiveEndTime = goodDto.couponEffectiveEndTime ?? ""
            if couponEffectiveEndTime.characters.count != 0{
                couponsEndTimeLab.text = "领券结束时间:" + couponEffectiveEndTime
            }
        }
        get{
            //返回 _成员变量
            return (self.goodDto)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        couponsView.isHidden = true
        couponsLab.layer.cornerRadius = 5
        couponsLab.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
