//
//  CAEmitterLayerView.h
//  粒子demo（模仿，下雨，下雪等效果）
//
//  Created by 刘博通 on 16/9/20.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAEmitterLayerView : UIView

//** 粒子发射器 */
@property (nonatomic ,weak)CAEmitterLayer *emitterLayer;


//显示出当前view
- (void)show;
//隐藏
- (void)hide;

@end
