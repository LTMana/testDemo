//
//  ViewModel.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/11.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewModel.h"



 @implementation ViewModel
{
    LTRequest *_request;
}


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    ViewModel *viewModel =[super allocWithZone:zone];
    
    if (viewModel) {
        [viewModel lt_initialize];
    }
    
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(LTRequest *)request
{
    if (!_request) {
        
        _request = [LTRequest request];
    }
    
    return _request;
}


-(void)lt_initialize{}

@end
