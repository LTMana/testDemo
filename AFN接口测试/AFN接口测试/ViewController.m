//
//  ViewController.m
//  AFN接口测试
//
//  Created by 刘博通 on 16/7/5.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "AFHTTPSessionManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    UIImageView * imageView =[[UIImageView alloc] init];
    imageView.frame =self.view.bounds;
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://newte.sh.1251225243.clb.myqcloud.com/TEGateway/c15550d9b28d2497197ac8cd6df385ec/Graphic/?bizcode=TRAFFICEYE&adcode=510100&id=0028_103_001&format=png&&width=385&height=315&customerid=trafficeye&version=1501"]];
    [self.view addSubview:imageView];
   
    
    
    
    
//    [[AFHTTPSessionManager manager] GET:@"http://newte.sh.1251225243.clb.myqcloud.com/TEGateway/c15550d9b28d2497197ac8cd6df385ec/Graphic/?bizcode=TRAFFICEYE&adcode=510100&id=0028_103_001&format=png&&width=385&height=315&customerid=trafficeye&version=1501" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
}

@end
