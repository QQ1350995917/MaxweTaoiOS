//
//  NetworkTool.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/22.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit
import AFNetworking

enum WZYRequestType {
    case Get
    case Post
}

class NetworkTool: AFHTTPSessionManager {

    static let shareInstance : NetworkTool = {
        let toolInstance = NetworkTool()
        toolInstance.responseSerializer.acceptableContentTypes?.insert("application/json")
        return toolInstance
    }()

    
    
    // 将成功和失败的回调分别写在两个逃逸闭包中
    func request(requestType : WZYRequestType, url : String, parameters : [String : Any], succeed : @escaping([String : Any]?) -> (), failure : @escaping(Error?) -> ()) {
        
        print("url:\(url)")
        
        //转化ASE加密模型
        let userParam = tosubmitModel(parameters: parameters)
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            
            print("resulet:\(responseObj)")
           
            let result = responseObj as? [String: Any]
            succeed(result)
            
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print(error)
        }
        
        // Get 请求
        if requestType == .Get {
            get(url, parameters: userParam, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .Post {
            post(url, parameters: userParam, progress: nil, success: successBlock, failure: failureBlock)
        }
    }

//    // 将成功和失败的回调写在一个逃逸闭包中
//    func request(requestType : WZYRequestType, url : String, parameters : [String : Any], resultBlock : @escaping([String : Any]?, Error?) -> ()) {
//        
//        // 成功闭包
//        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
//            resultBlock(responseObj as? [String : Any], nil)
//        }
//        
//        // 失败的闭包
//        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
//            resultBlock(nil, error)
//        }
//        
//        // Get 请求
//        if requestType == .Get {
//            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
//        }
//        
//        // Post 请求
//        if requestType == .Post {
//            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
//        }
//    }
    
    
    //将字典分为几部走 最后加密成想要的提交模型
    func tosubmitModel(parameters:[String: Any]) -> [String:String] {
        //将传入的字典转换为jison字符串
        let jsonStr = toJSONString(dict: parameters as NSDictionary?)
        //base64编码,转化为 NSData数据
        let utf8EncodeData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        //将NSData进行Base64编码
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        //进行AES 加密
        let key = "PollKingTueJan10" //key
        guard let str = NSData.aes128Encrypt(base64String, key: key)  else {
            return ["p":""]
        }
        print("加密后的字符串\(str)")
        return ["p":str]
    }
    //将字典转为json
    func toJSONString(dict:NSDictionary?)->String{
        
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        return strJson! as String
        
    }


}
