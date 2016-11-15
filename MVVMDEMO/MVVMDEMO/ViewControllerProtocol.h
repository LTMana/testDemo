//
//  ViewControllerProtocol.h
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewProtocol.h"

@protocol ViewControllerProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <ViewProtocol>)viewModel;

- (void)lt_bindViewModel;
- (void)lt_addSubviews;
- (void)lt_getNewData;
- (void)lt_layoutNavigation;

@end