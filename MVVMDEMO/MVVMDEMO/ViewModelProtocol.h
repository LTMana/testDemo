//
//  ViewModelProtocol.h
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/11.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LSHeaderRefresh_HasMoreData = 1,
    LSHeaderRefresh_HasNoMoreData,
    LSFooterRefresh_HasMoreData,
    LSFooterRefresh_HasNoMoreData,
    LSRefreshError,
    LSRefreshUI,
} LSRefreshDataStatus;


@protocol ViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

@property (strong, nonatomic)LTRequest *request;

/**
 *  初始化
 */
- (void)lt_initialize;

@end
