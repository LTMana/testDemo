//
//  AppDelegate.m
//  画页迁移
//
//  Created by 刘博通 on 16/5/26.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"当程序载入后执行");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"应用程序将要进入非活动状态，即将进入后台");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   NSLog(@"如果应用程序支持后台运行，则应用程序已经进入后台运行");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   NSLog(@"应用程序将要进入活动状态，即将进入前台运行");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"应用程序已进入前台，处于活动状态");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"应用程序将要退出，通常用于保存书架喝一些推出前的清理工作");
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
     NSLog(@"系统内存不足，需要进行清理工作");
}
-(void)applicationSignificantTimeChange:(UIApplication *)application
{
    NSLog(@"当系统时间发生改变时执行");
}

@end
