//
//  AppDelegate.m
//  ddddsa
//
//  Created by 刘博通 on 16/7/26.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "AppDelegate.h"
#import "CNMKSysConfigure.h"
#import "CNMKManager.h"
@interface AppDelegate ()

@end
@implementation AppDelegate
//...中文瓦片地图地址
#define HTTPURL_MAP_CN @"http:www.trafficeye.com.cn/fmapimg_bigfont_chi_day"
//...路况地图地址
#define HTTPURL_MAP_DTM     @"http://www.trafficeye.com.cn/dtmimg/"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Sysfmappmg_cn = HTTPURL_MAP_CN;
    Sysdtmimg = HTTPURL_MAP_DTM;
    
    //...注册启动地图
    CNMKManager *manager = [[CNMKManager alloc] init];
    BOOL registerState = [manager start:@"Basic Y2VubmF2aVRlc3Q6Y2VubmF2aVRlc3Q="];
    if (registerState == NO)
    {
        NSLog(@"当前授权失败!");
    }
    else
    {
        NSLog(@"当前授权成功!");
    }

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
