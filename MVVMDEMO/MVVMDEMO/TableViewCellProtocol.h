//
//  TableViewCellProtocol.h
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TableViewCellProtocol <NSObject>

@optional


- (void)lt_setupViews;
- (void)lt_bindViewModel;

@end
