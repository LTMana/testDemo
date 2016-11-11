//
//  CaculatorMaker.m
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/1.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "CaculatorMake.h"

@implementation CaculatorMake

-(CaculatorMake *(^)(NSInteger))add
{
    return ^CaculatorMake *(NSInteger value){
        
        _result += value;
        
        return self;
    };
}

-(CaculatorMake *(^)(NSInteger))subtraction
{
    return ^CaculatorMake *(NSInteger value){
        
        _result -= value;
        
        return self;
    };
}


@end
