//
//  ViewController.m
//  粒子demo（模仿，下雨，下雪等效果）
//
//  Created by 刘博通 on 16/9/20.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import "snow.h"
#import "CAEmitterBaseLayer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    snow *sView = [[snow alloc] initWithFrame:self.view.bounds];
//
////    snow *sView =[[snow alloc] init];
////    sView.frame = CGRectMake(100, 400, self.view.bounds.size.width, self.view.bounds.size.height);
//    sView.backgroundColor =[UIColor blackColor];
//    NSLog(@"%@",NSStringFromCGRect(sView.frame));
//    [self.view addSubview:sView];
//    [sView show];
    self.view.backgroundColor =[UIColor lightGrayColor];
    CAEmitterBaseLayer *base =[CAEmitterBaseLayer baseLayer];
    
    base.styleMode = CAEmitterStyleRarin;
    
    
    [self.view.layer addSublayer: base];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
