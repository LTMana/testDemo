//
//  NSObject+Claculate.m
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/1.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "NSObject+Claculate.h"
#import "CaculatorMake.h"
@implementation NSObject (Claculate)

+ (NSInteger)makeCaculators:(void(^)(CaculatorMake *make))caculatorMaker
{
    
    CaculatorMake *mgr =[[CaculatorMake alloc] init];
    caculatorMaker(mgr);
    
    return mgr.result;
}

@end
