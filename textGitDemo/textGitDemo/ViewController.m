//
//  ViewController.m
//  textGitDemo
//
//  Created by 刘博通 on 16/5/10.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import "drawB.h"
#import "hci_tts_player.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    drawB *d=[[drawB alloc]init];
//    d.frame =self.view.bounds;
//    
//    [self.view addSubview:d];
    // Do any additional setup after loading the view, typically from a nib.
        [self.view layoutIfNeeded];
}


- (void)drawRect:(CGRect)rect {

    self.view.frame =rect;
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
    [self.view setNeedsDisplay];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
