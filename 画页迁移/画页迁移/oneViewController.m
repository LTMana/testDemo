//
//  oneViewController.m
//  
//
//  Created by 刘博通 on 16/5/26.
//
//

#import "oneViewController.h"

@interface oneViewController ()

@end

@implementation oneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"OneViewDidLoad-加载视图");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"OneViewWillAppear-视图将要显示");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"OneViewDidAppear-视图已经显示");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"OneViewWillDisappear-视图将要消失");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"OneViewDidDisappear-视图已经消失");
}

@end
