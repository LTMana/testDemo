//
//  TwoViewController.m
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/3.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "TwoViewController.h"


@interface TwoViewController ()



@end



@implementation TwoViewController

- (IBAction)twoBtn:(id)sender {

    if (self.delegateSignal) {
          [self.delegateSignal sendNext:nil];
    }
    
    
    
}

@end
