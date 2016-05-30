//
//  AdaptiveHeight.h
//  iOSSDKDemo
//
//  Created by lvzx on 15/11/20.
//  Copyright © 2015年 zhouxg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdaptiveHeight : NSObject

+ (instancetype)singleHandle;

- (CGFloat)heightWithString:(NSString *)string stringFont:(CGFloat)font stringSize:(CGFloat)width;

@end
