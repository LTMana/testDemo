//
//  NSObject+Claculate.h
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/1.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CaculatorMake;
@interface NSObject (Claculate)

+ (NSInteger)makeCaculators:(void(^)(CaculatorMake *make))caculatorMaker;



@end
