//
//  TwoViewController.h
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/3.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface TwoViewController : UIViewController
@property (nonatomic, strong) RACSubject *delegateSignal;
@end
