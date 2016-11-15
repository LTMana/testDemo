//
//  ViewController.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/8.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    ViewController *viewController =[super allocWithZone:zone];
    
    @weakify(viewController)
    
   [[viewController rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
        [viewController lt_addSubviews];
        [viewController lt_bindViewModel];
         
    }];
    
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController lt_layoutNavigation];
        [viewController lt_getNewData];
    }];

    
 
     return viewController;
}



#pragma mark - RAC
/**
 *  添加控件
 */
- (void)lt_addSubviews {}

/**
 *  绑定
 */
- (void)lt_bindViewModel {}

/**
 *  设置navation
 */
- (void)lt_layoutNavigation {}

/**
 *  初次获取数据
 */
- (void)lt_getNewData {}


@end
