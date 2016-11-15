//
//  LTViewModel.h
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewModel.h"
#import "LTModel.h"
@interface LTViewModel : ViewModel

@property (nonatomic ,strong) LTModel    *model;


@property (nonatomic ,strong) RACSubject *refreshEndSubject;
@property (nonatomic ,strong) RACSubject *refreshUI;
@property (nonatomic ,strong) RACSubject *cellClickSubject;
@property (nonatomic ,strong) RACCommand *refreshDataCommand;
@property (nonatomic ,strong) RACCommand *nextPageCommand;
@property (nonatomic ,strong) NSMutableArray *dataArray;


@end
