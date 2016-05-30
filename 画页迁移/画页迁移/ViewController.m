//
//  ViewController.m
//  画页迁移
//
//  Created by 刘博通 on 16/5/26.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"TabViewDidLoad-加载视图");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"TabViewWillAppear-视图将要显示");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"TabViewDidAppear-视图已经显示");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"TabViewWillDisappear-视图将要消失");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"TabViewDidDisappear-视图已经消失");
}


@end
