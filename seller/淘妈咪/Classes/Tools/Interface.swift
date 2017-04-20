//
//  Interface.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/22.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

let DOMAIN = "http://taomami.net"

//用户接口
//MARK: - 用户登录注册相关
//检验手机号 是否注册      -> body内容：cellphone	String
func existAccount()->String{
    return "\(DOMAIN)/user/exist"
}
//发送短信验证码          ->body内容：cellphone	  String
func smsCodeAccount()->String{
    return "\(DOMAIN)/meta/smsCode"
}
//用户注册
/*
->body内容：
 apt	       number      1	固定值
 cellphone	   String	     	手机号码
 smsCode	   String       	手机短信验证码号码
 password	   String	     	6到12位密码
*/
func signupAccount()->String{
    return "\(DOMAIN)/user/signup"
}
//用户登录
/*
 apt	       number      1	固定值
 cellphone	   String	     	手机号码
 password      String           6到12位密码
 */
func signinAccount()->String{
    return "\(DOMAIN)/user/signin"
}
//忘记密码
/*
 ->body内容：
 apt	       number      1	固定值
 cellphone	   String	     	手机号码
 smsCode	   String       	手机短信验证码号码
 password	   String	     	6到12位密码
 */
func lostAccount()->String{
    return "\(DOMAIN)/user/lost"
}

//修改密码
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 authenticatePassword	String		6到12位密码,原密码
 password	   String	    	6到12位密码,新密码
 */

func passwordAccount()->String{
    return "\(DOMAIN)/user/password"
}
//用户退出
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 */
func signoutAccount()->String{
    return "\(DOMAIN)/user/signout"
}
//用户信息获取出
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 */
func mineAccount()->String{
    return "\(DOMAIN)/user/mine"
}
//用户激活
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 actCode       String           八位激活码
 authenticatePassword   String   敏感操作，输入密码
 */
func activeAccount()->String{
    return "\(DOMAIN)/user/active"
}
//用户更新申请语
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 reason	       String		    4个到200个字符 
 */
func updateReasonAccount()->String{
    return "\(DOMAIN)/user/updateReason"
}
//用户更新推广语
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 rhetoric	   String	    	0个到60个
 */
func updateRhetoricAccount()->String{
    return "\(DOMAIN)/user/updateRhetoric"
}

//MARK: - 淘宝商品相关
//获取淘宝商品列表
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 toPage        number           第N页
 perPageSize   number           每页显示N条数据
 q             String           查询关键字或产品URL
 cookie        String           登录淘宝后的cookie
 sortType      number           0:默认 7:佣金高到低 3:价格高到低 4:价格低到高 9:销量高到低	排序类型
 urlType       number           0:淘宝商品 1:高佣金商品 2:站内商品 链接类型标记
 dpyhq         number           1：拥有 其他：无	店铺优惠券
 */
func searchAccount()->String{
    return "\(DOMAIN)/tao/search"
}
//获取淘宝商品转链
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 cookie	       String	    	登录淘宝后的cookie
 auctionid	   number	    	商品的ID
 siteid	       number	     	导购推广ID
 adzoneid	   number	     	推广位的ID
 */

func auctionAccount()->String{
    return "\(DOMAIN)/tao/auction"
}

//MARK: -推广位相关
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 cookie	       String	     	登录淘宝后的cookie
 */
func brandsAccount()->String{
    return "\(DOMAIN)/tao/brands"
}
//创建推广位
/*
 ->body内容：
 t	           String	    	token
 id	           number	      	ID
 cellphone	   String	     	手机号码
 apt	       number	   1    固定值
 sign	       String	     	签名
 cookie	       String	     	登录淘宝后的cookie
 guideName	   String	        淘妈咪导购推广	 导购推广位名称
 adZoneName	   String	        淘妈咪导购推广位	推广位的名称
 weChat	       String	     	微信号
 */
func createBrandsAccount()->String{
    return "\(DOMAIN)/tao/createBrands"
}

