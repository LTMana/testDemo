//
//  Caculator.m
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/3.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "Caculator.h"

@implementation Caculator


-(Caculator *)caculator:(NSInteger (^)(NSInteger result))caculator
{
    
    _result = caculator(_result);
    
    return self;
}

-(Caculator *)equle:(BOOL (^)(NSInteger result))operation
{
    _isEqule = operation(_result);
    
    return self;
}


@end
