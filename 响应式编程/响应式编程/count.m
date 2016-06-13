//
//  count.m
//  响应式编程
//
//  Created by liubotong on 16/6/10.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import "count.h"

@implementation count


static id _instance;
+ (instancetype)sharedInstanceTool{
    @synchronized(self){
        if(_instance == nil){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

NSString * indexaa;
-(void)setCount:(NSString *)count
{
    _count =[NSString stringWithFormat:@"liubotong_%@",count];;

    
    
    
    
}

-(void)aa
{
    static int i;
    i++;
    indexaa=[NSString stringWithFormat:@"%d",i];
   
}
@end
