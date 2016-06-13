//
//  count.h
//  响应式编程
//
//  Created by liubotong on 16/6/10.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface count : NSObject
@property (nonatomic ,strong)NSString *count;
+ (instancetype)sharedInstanceTool;
@end
