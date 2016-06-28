//
//  RedView.h
//  
//
//  Created by 刘博通 on 16/6/16.
//
//

#import <UIKit/UIKit.h>

@class RedView,BlueView;

@protocol RedViewDelegate <NSObject>

-(void)RedView:(BlueView *)redView cilkEvent:(NSString *)event;

@optional
-(void)ddddd:(NSString *)str;
@end
@interface RedView : UIView




-(void)addBlue:(id<RedViewDelegate>)blueDelegate;
@end
