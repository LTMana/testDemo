//
//  LTModel.h
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTModel : NSObject
// 属性
@property (nonatomic,strong)NSString *rating;  // 评分
@property (nonatomic,strong)NSString *pubdate;  // 上映日期
@property (nonatomic,strong)NSString *title;  // 电影名
@property (nonatomic,strong)NSDictionary *images;  // 海报数组

@end
