//
//  TwoViewController.m
//  
//
//  Created by 刘博通 on 16/5/26.
//
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"TwoViewDidLoad-加载视图");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"TwoViewWillAppear-视图将要显示");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"TwoViewDidAppear-视图已经显示");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"TwoViewWillDisappear-视图将要消失");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"TwoViewDidDisappear--视图已经消失");
}
@end
