//
//  CAEmitterBaseLayer.m
//  粒子demo（模仿，下雨，下雪等效果）
//
//  Created by 刘博通 on 16/9/21.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "CAEmitterBaseLayer.h"
#import "SnowEmitterCell.h"
#import "RainEmitterCell.h"




@implementation CAEmitterBaseLayer


-(instancetype)initWithLayer:(id)layer
{
    if (self =[super initWithLayer:layer]) {
        //设置阴影
        self.shadowOpacity = 1.0;
        self.shadowRadius  = 0.0;
        self.shadowOffset  = CGSizeMake(0.0, 1.0);
        self.shadowColor   = [[UIColor whiteColor] CGColor];
 
    }
    return self;
}


+(instancetype)baseLayer
{
    return [self layer];
}

-(void)setStyleMode:(CAEmitterStyle)styleMode
{
    if (styleMode == CAEmitterStyleSnow) {
        //粒子发射器
       
        
        //粒子发射的位置
        
        self.emitterPosition = CGPointMake([UIScreen mainScreen].bounds.size.width/2, -20);
        //发射源的大小
        self.emitterSize		= CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.0);;
        //发射模式
        self.emitterMode		= kCAEmitterLayerOutline;
        //发射源的形状
        self.emitterShape	= kCAEmitterLayerLine;
        
      
        
        
        //创建雪花粒子
        SnowEmitterCell *snowflake = [SnowEmitterCell snowShow];
       
        
        
        
        // 将粒子添加到粒子发射器上
        self.emitterCells = [NSArray arrayWithObject:snowflake];
        
        
    }else if (styleMode == CAEmitterStyleRarin){
        
       
        //粒子发射的位置
        
        self.emitterPosition = CGPointMake([UIScreen mainScreen].bounds.size.width/2, -64);
        //发射源的大小
        self.emitterSize		= CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.0);;
        //发射模式
        self.emitterMode		= kCAEmitterLayerOutline;
        //发射源的形状
        self.emitterShape	= kCAEmitterLayerLine;
        
        
        
        
        //粒子的名称
        
        RainEmitterCell *rainFlake = [RainEmitterCell rainShow];
                
        
        
        // 将粒子添加到粒子发射器上
        self.emitterCells = [NSArray arrayWithObject:rainFlake];
        //    [self.view.layer insertSublayer:snowEmitter atIndex:0];
     

        
    }
}

@end
