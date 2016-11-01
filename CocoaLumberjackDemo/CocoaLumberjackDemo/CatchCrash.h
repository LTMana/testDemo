//
//  CatchCrash.h
//  CocoaLumberjackDemo
//
//  Created by 刘博通 on 16/8/18.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatchCrash : NSObject
void uncaughtExceptionHandler(NSException *exception);
@end
