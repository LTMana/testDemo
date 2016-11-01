//
//  ViewController.m
//  nodeJS
//
//  Created by 刘博通 on 16/10/20.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *nodeWeb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nodeWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.nodebeginner.org/index-zh-cn.html#javascript-and-nodejs"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
