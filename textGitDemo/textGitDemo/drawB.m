//
//  drawB.m
//  
//
//  Created by 刘博通 on 16/5/11.
//
//

#import "drawB.h"

@implementation drawB



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIColor *color =[UIColor redColor];
//        self.backgroundColor =color;

    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    UIBezierPath *mPath = [UIBezierPath bezierPath];
    [mPath moveToPoint:CGPointMake(100, 100)]; //创建一个点
    [mPath addLineToPoint:CGPointMake(100, 300)]; // 加条线,从点移动到另一个点
    [mPath addLineToPoint:CGPointMake(300, 300)]; // 加条线,从点移动到另一个点
    [mPath closePath]; // 关闭贝塞尔线
    
   
    UIColor *fillColor = [UIColor greenColor];          //设置颜色
    [fillColor set];                                    //填充颜色
    [mPath fill];                                       //贝塞尔线进行填充
    
    UIColor *stroke = [UIColor redColor];               //设置红色画笔线
    [stroke set];                                       //填充颜色
    [mPath stroke];
    
  }



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor =[UIColor whiteColor];
    [self layoutIfNeeded];
}


@end
