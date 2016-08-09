//
//  ViewController.m
//  jspatchDemo
//
//  Created by 刘博通 on 16/7/4.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong ,nonatomic) NSArray *array;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *oldArr=@[@2,@4,@6];
    NSArray *newArr = @[@1,@2,@3];
   
  
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",oldArr];
    //过滤数组
    NSArray * reslutFilteredArray = [newArr filteredArrayUsingPredicate:filterPredicate];
    NSLog(@"Reslut Filtered Array = %@",reslutFilteredArray);
    
   
}

- (IBAction)touchError:(id)sender {
    
    
    
    [self errorErray]; //触发越界错误
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)errorErray {
    _array = [NSArray array];

       
    self.textlabel.text =self.array[2];
    
}




-(void)error
{
    exit(0);
}

@end
