//
//  ViewController.m
//  代理对象为参数
//
//  Created by 刘博通 on 16/6/16.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"
#import "BlueView.h"
@interface ViewController ()<RedViewDelegate>
@property (weak, nonatomic) IBOutlet BlueView *redview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.redview initForDelegate:self];
    
//    self.redview.redDelegate =self;
    
   
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)ddddd:(NSString *)str
{
    NSLog(@"%@",str);
}

-(void)RedView:(RedView *)redView cilkEvent:(NSString *)event
{
    NSLog(@"%@",event);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
