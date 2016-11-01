//
//  ViewController.m
//  CocoaLumberjackDemo
//
//  Created by 刘博通 on 16/8/18.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static const NSUInteger ddLogLevel = DDLogLevelAll;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *arr =@[@"1",@"3",@"3",@"4"];
    NSMutableArray *temp =[NSMutableArray array];
    
    [temp addObjectsFromArray:arr];
    
    NSLog(@"old-temp:%@",temp);
    
    NSMutableArray *removeArr =[NSMutableArray array];
    for (int i =0; i<temp.count; i++) {
        
       
        [removeArr addObject:[temp objectAtIndex:i]];
        
       
    }
    [temp removeObjectsInArray:removeArr];
    
    NSLog(@"new -temp:%@",temp);
    
   
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
