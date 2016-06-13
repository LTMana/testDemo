//
//  calculateManager.m
//  函数式编程
//
//  Created by liubotong on 16/6/11.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import "calculateManager.h"

@implementation calculateManager
-(instancetype)calculate:(int(^)(int))calculate
{
    
    
    _result =calculate(_result);
    
    
    return self;
}
@end
