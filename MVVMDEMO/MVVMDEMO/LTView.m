//
//  LTView.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "LTView.h"
#import "LTViewModel.h"

@interface LTView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

/** VIewModel */
@property (nonatomic ,strong) LTViewModel *viewModel;

@end


@implementation LTView


-(instancetype)initWithViewModel:(id<ViewModelProtocol>)viewModel
{
    self.viewModel = (LTViewModel *)viewModel;
    
    return [super initWithViewModel:viewModel];
}

-(void)lt_setupViews
{
    [self addSubview:self.tableView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)lt_bindViewModel
{
    [self.viewModel.refreshDataCommand execute:nil];
     @weakify(self)
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        @strongify(self)
        
        [self.tableView reloadData];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        
    }];
    
    
    
}





@end
