//
//  LocalAuthcodeView.h
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/23.
//  Copyright © 2017年 韩景军. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRandomColor  [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];
#define kLineCount 6
#define kLineWidth 1.0
#define kCharCount 5
#define kFontSize [UIFont systemFontOfSize:arc4random() % 5 + 15]

@interface LocalAuthcodeView : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串
- (void)getAuthcode;

@end
