//
//  snow.m
//  粒子demo（模仿，下雨，下雪等效果）
//
//  Created by 刘博通 on 16/9/20.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "snow.h"

@implementation snow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    //初始化一些参数
    self.emitterLayer.masksToBounds = YES;
    self.emitterLayer.emitterShape = kCAEmitterLayerLine;
    self.emitterLayer.emitterMode = kCAEmitterLayerSurface;
    self.emitterLayer.emitterSize = self.frame.size;
    self.emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width / 2.f, -20);
}

- (void)show {
    //配置
    CAEmitterCell *snowFlake = [CAEmitterCell emitterCell];
    snowFlake.birthRate = 1.f;
    snowFlake.speed = 10.f;
    snowFlake.velocity = 2.f;
    snowFlake.velocityRange = 10.f;
    snowFlake.yAcceleration = 10.f;
    snowFlake.emissionRange = 0.5 * M_PI;
    snowFlake.spinRange = 0.25 * M_PI;
    snowFlake.contents = (__bridge id _Nullable)([UIImage imageNamed:@"DazFlake"].CGImage);
    snowFlake.color = [UIColor whiteColor].CGColor;
    snowFlake.lifetime = 180.f;
    snowFlake.scale = 0.5;
    snowFlake.scaleRange = 0.3;
    
    //添加动画
    self.emitterLayer.emitterCells = @[snowFlake];
}

@end
