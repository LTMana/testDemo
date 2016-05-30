//
//  NavigationViewController.m
//  
//
//  Created by 刘博通 on 16/5/26.
//
//

#import "NavigationViewController.h"
#import "ViewController.h"
@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"NavViewDidLoad-加载视图");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"NavViewWillAppear-视图将要显示");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"NavViewDidAppear-视图已经显示");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"NavViewWillDisappear-视图将要消失");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"NavViewDidDisappear-视图已经消失");
}


@end
