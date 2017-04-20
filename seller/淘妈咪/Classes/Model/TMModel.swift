//
//  TMModel.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/23.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import Foundation
//个人信息
class MineDto: HandyJSON {
    var id: Int?                  //id
    var cellphone: String?        //手机号码
    var name: String?             //姓名
    var actCode: String?          //是否激活
    var actTime: Int?             //激活时间
    var password: String?         //密码
    var status: Int?              //
    var updateTime: Int?          //上传时间
    var createTime:Int?           //创建时间
    var reason: String?     //申请佣金理由
    var rhetoric: String?   //推广语
    required init(){}
}

//获取的商品信息
class GoodsEntitiesDto: HandyJSON {
    var auctionId: Int?                        //id
    var auctionTag: String?
    var auctionUrl: String?
    var biz30day: Int?                        //月销量
    var couponActivityId :Int?                //null
    var couponAmount: Int?                    // 优惠券的面值
    var couponEffectiveEndTime: String?       //
    var couponEffectiveStartTime: String?     //
    var couponInfo: String?                   //使用优惠券的条件
    var couponLeftCount: Int?                 //优惠券剩余数量
    var couponLink: String?
    var couponLinkTaoToken: String?
    var couponOriLink: String?                //null
    var couponShortLink: String?              //null
    var couponStartFee: Float?                  //优惠券使用的起始价格
    var couponTotalCount: Int?                //优惠券总数量
    var dayLeft: Int?                         //活动剩余天数
    var debugInfo: String?                    //null
    var eventCreatorId: Int?
    var eventRate: Float?                       //比率
    var hasRecommended: Int?
    var hasSame: Int?
    var hasUmpBonus: String?                  //null
    var includeDxjh: Int?
    var isBizActivity: String?                //null
    var leafCatId: Int?
    var nick: String?                         //昵称
    var pictUrl: String?
    var reservePrice: Float?                    // 原价
    var rlRate: Float?
    var rootCatId: Int?
    var rootCatScore: Int?
    var rootCategoryName: String?
    var sameItemPid: String?
    var sellerId: Int?                        //卖家的ID
    var shopTitle: String?                    // 店家名称
    var title: String?
    var tk3rdRate: Float?
    var tkCommFee: Float?
    var tkRate: Float?                          //比率
    var tkSpecialCampaignIdRateMap: [String:String]?   //null
    var totalFee: Int?
    var totalNum: Int?
    var umpBonus: String?                     //null
    var userType: Int?                        //0 淘宝 1天猫
    var userTypeName: String?                 //null
    var zkPrice: Float?                      //现价
    required init(){}
}
//获取淘宝商品转链 
class auctionDto: HandyJSON {
    var taoToken: String?                //普通淘口令
    var shortLinkUrl: String?            //普通下单短链接
    var clickUrl: String?                //普通下单长链接
    
    var couponLinkTaoToken: String?      //带有优惠券的淘口令
    var couponShortLinkUrl: String?      //带有优惠券的短链接
    var couponLink: String?              //带有优惠券的长连接
    
    var qrCodeUrl: String?               //二维码
    var type: String?                    //"auction"
    required init(){}
}

//推广位 所有
class brandsDto: HandyJSON {
    var name: String?                //
    var siteId: String?
    var adZones: [adZonesDto]?
    required init(){}
}

//推广位 详细
class adZonesDto: HandyJSON {
    var id: String?                  //id
    var name: String?                //
    var siteId: String?
    required init(){}
}

