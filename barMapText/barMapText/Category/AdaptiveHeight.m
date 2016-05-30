//
//  AdaptiveHeight.m
//  iOSSDKDemo
//
//  Created by lvzx on 15/11/20.
//  Copyright © 2015年 zhouxg. All rights reserved.
//

#import "AdaptiveHeight.h"

@implementation AdaptiveHeight

+ (instancetype)singleHandle {
    static AdaptiveHeight *ah = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ah = [[AdaptiveHeight alloc] init];
    });
    return ah;
}

/**
 *  自适应高度
 *
 *  @param string 传入的文字
 *  @param font   文字尺寸
 *  @param size   宽,高
 *
 *  @return 返回高度
 */
- (CGFloat)heightWithString:(NSString *)string stringFont:(CGFloat)font stringSize:(CGFloat)width{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}
@end
