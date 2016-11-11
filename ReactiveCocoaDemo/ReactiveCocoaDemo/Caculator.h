//
//  Caculator.h
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/3.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caculator : NSObject
/**是否相等*/
@property (nonatomic, assign) BOOL isEqule;
/**计算结果*/
@property (nonatomic, assign) NSInteger result;

-(Caculator *)caculator:(NSInteger (^)(NSInteger result))caculator;

-(Caculator *)equle:(BOOL (^)(NSInteger result))operation;


@end
