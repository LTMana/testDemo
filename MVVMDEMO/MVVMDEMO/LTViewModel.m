//
//  LTViewModel.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "LTViewModel.h"

@implementation LTViewModel

-(void)jm_initialize
{
    @weakify(self)
    
   [ self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dic) {
    
       @strongify(self)
       
       NSMutableArray *dataArray =dic[@"entries"];
       
       for (int i =0; i<dataArray.count; i++) {
           
           LTModel *model =[LTModel mj_objectWithKeyValues:dataArray[i]];
           
           [self.dataArray addObject:model];
           
        }
       
       [self.refreshUI sendNext:nil];
       
       [self.refreshEndSubject sendNext:@(LSFooterRefresh_HasMoreData)];
       
       
   }];
    
}

#pragma mark - 懒加载

-(RACCommand *)refreshDataCommand{
    
    if (!_refreshDataCommand) {
        
     @weakify(self)
     _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         
         @strongify(self)
         
         return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           @strongify(self)
           
           [self.request GET:LISTURL parameters:nil success:^(LTRequest *request, id response) {
               
               [subscriber sendNext:response];
               [subscriber sendCompleted];
               
           } failure:^(LTRequest *request, NSError *error) {
               [subscriber sendError:[NSError errorWithDomain:@"请求出错" code:0 userInfo:nil]];
               [subscriber sendCompleted];
               
           }];
             
             
             return nil;
         }];
         
         
    }];
        
}
    
    return _refreshDataCommand;
    
}


-(RACSubject *)refreshUI
{
    if (!_refreshUI) {
        _refreshUI = [RACSubject subject];
    }
    return _refreshUI;
}

-(RACSubject *)refreshEndSubject
{
    if (!_refreshEndSubject) {
        
        _refreshEndSubject = [RACSubject subject];
    }
    
    return _refreshEndSubject;
}

-(RACSubject *)cellClickSubject
{
    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}


-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


@end
