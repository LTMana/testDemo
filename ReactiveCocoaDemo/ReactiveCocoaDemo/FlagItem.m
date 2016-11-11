//
//  FlagItem.m
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/4.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "FlagItem.h"

@implementation FlagItem


+(instancetype)flagWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithFlags:dict];
}


-(instancetype)initWithFlags:(NSDictionary *)dict
{
    if (self =[super init]) {
//        _name = dict[@"name"];
//        _age  = [dict[@"age"] integerValue];
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

@end
