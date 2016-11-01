//
//  SnowEmitterCell.m
//  粒子demo（模仿，下雨，下雪等效果）
//
//  Created by 刘博通 on 16/9/21.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "SnowEmitterCell.h"

@implementation SnowEmitterCell


-(instancetype)init
{
    if (self =[super init]) {
        self.name = @"snow";
        self.birthRate = 1.f;
        self.speed = 10.f;
        self.velocity = 2.f;
        self.velocityRange = 10.f;
        self.yAcceleration = 10.f;
        self.emissionRange = 0.5 * M_PI;
        self.spinRange = 0.25 * M_PI;
        self.contents = (__bridge id _Nullable)([UIImage imageNamed:@"DazFlake"].CGImage);
        self.color = [UIColor redColor].CGColor;
        self.lifetime = 180.f;
        self.scale = 0.5;
        self.scaleRange = 0.3;

    }
    
    return self;
}


+(instancetype)snowShow
{
    
    
    return [self emitterCell];
}

@end
