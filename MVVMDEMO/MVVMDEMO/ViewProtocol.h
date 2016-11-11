//
//  ViewProtocol.h
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/11.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewProtocol <NSObject>


@optional


- (void)lt_bindViewModel;
- (void)lt_setupViews;


@end