//
//  NSData+AES.h
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/22.
//  Copyright © 2017年 韩景军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;
@interface NSData (AES)

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;

//+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;
// 普通字符串转换为十六进
+(NSString *)hexStringFromData:(NSData *)data;
//十六进制转换为普通字符串的
+ (NSString *)convertHexStrToString:(NSString *)str;


@end
