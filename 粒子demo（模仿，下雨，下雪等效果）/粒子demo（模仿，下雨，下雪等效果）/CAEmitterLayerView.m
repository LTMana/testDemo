//
//  CAEmitterLayerView.m
//  粒子demo（模仿，下雨，下雪等效果）
//
//  Created by 刘博通 on 16/9/20.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "CAEmitterLayerView.h"

@implementation CAEmitterLayerView
{
    CAEmitterLayer *_emitterLayer;
}

+(Class)layerClass
{
   return [CAEmitterLayer class];
}


-(instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        _emitterLayer = (CAEmitterLayer *)self.layer;
    }
    return self;
}

-(void)setEmitterLayer:(CAEmitterLayer *)emitterLayer
{
    _emitterLayer =emitterLayer;
}


-(CAEmitterLayer *)emitterLayer
{
    return _emitterLayer;
}



-(void)show
{
    
}


-(void)hide
{
    
}

@end
