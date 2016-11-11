//
//  FlagItem.h
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/4.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlagItem : NSObject

+(instancetype)flagWithDict:(NSDictionary *)dict;


-(instancetype)initWithFlags:(NSDictionary *)dict;

/** 名字 */
@property (nonatomic, copy) NSString *name;

/**年龄*/
@property (nonatomic, assign) NSInteger age;


@end
