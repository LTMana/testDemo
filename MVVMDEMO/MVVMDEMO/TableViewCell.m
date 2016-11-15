//
//  TableViewCell.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self lt_setupViews];
        [self lt_bindViewModel];
        
        
    }
    
    return self;
}


- (void)lt_setupViews{}

- (void)lt_bindViewModel{}

@end
