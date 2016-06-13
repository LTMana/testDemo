//
//  calculateManager.h
//  函数式编程
//
//  Created by liubotong on 16/6/11.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calculateManager : NSObject
@property (nonatomic ,assign) int result;

-(instancetype)calculate:(int(^)(int))calculate;
@end
