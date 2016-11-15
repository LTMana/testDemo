//
//  View.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/11.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "View.h"

@implementation View

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self lt_setupViews];
        [self lt_bindViewModel];
    }
    return self;
}

-(instancetype)initWithViewModel:(id<ViewProtocol>)viewModel
{
    self = [super init];
    if (self) {
        
        [self lt_setupViews];
        [self lt_bindViewModel];
    }
    return self;

}


-(void)lt_setupViews
{
    
}


-(void)lt_bindViewModel
{
    
}


@end
