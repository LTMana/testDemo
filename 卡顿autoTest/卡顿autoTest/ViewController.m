//
//  ViewController.m
//  卡顿autoTest
//
//  Created by 刘博通 on 16/10/9.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self textddddd];
  }


-(void)textddddd
{
    for (int i=0;i<100000000; i++) {
        
        NSLog(@"23232");
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
