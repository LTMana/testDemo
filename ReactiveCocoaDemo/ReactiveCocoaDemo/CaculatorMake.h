//
//  CaculatorMaker.h
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/1.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMake : NSObject
/**计算结果*/
@property (nonatomic, assign) NSInteger result;

-(CaculatorMake *(^)(NSInteger))add;

-(CaculatorMake *(^)(NSInteger))subtraction;

@end
