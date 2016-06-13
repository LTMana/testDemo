//
//  ViewController.m
//  函数式编程
//
//  Created by liubotong on 16/6/11.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import "ViewController.h"
#import "calculateManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    calculateManager *mgr=[[calculateManager alloc] init];
    
  int dd=  [mgr calculate:^int(int result) {
        
        result+=5;
        
        result*=10;
        
        return result;
        
    }].result;
    
    
    NSLog(@"%d",dd);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
