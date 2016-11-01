//
//  rainEmitterCell.m
//  粒子demo（模仿，下雨，下雪等效果）
//
//  Created by 刘博通 on 16/9/21.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "RainEmitterCell.h"

@implementation RainEmitterCell


-(instancetype)init
{
    if (self =[super init]) {
        self.name = @"rain";
        self.birthRate = 25.f;
        self.speed = 10.f;
        self.velocity = 10.f;
        self.velocityRange = 10.f;
        self.yAcceleration = 1000.f;
        self.contents = (__bridge id _Nullable)([UIImage imageNamed:@"rain_animotion"].CGImage);
        self.color = [UIColor colorWithRed:225.f/255.f green:245.f/255.f blue:252.f/255.f alpha:1].CGColor;
        self.lifetime = 100.f;
        self.scaleRange = 0.f;
        self.scale = 0.2f;

    }
    
    return self;
}

+(instancetype)rainShow
{
    return [self emitterCell];
}

@end
