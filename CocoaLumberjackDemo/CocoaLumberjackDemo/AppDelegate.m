//
//  AppDelegate.m
//  CocoaLumberjackDemo
//
//  Created by 刘博通 on 16/8/18.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "CatchCrash.h"
@interface AppDelegate ()

@end
static const NSUInteger ddLogLevel = DDLogLevelAll;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       // Enable Colors
    //注册消息处理函数的处理方法
    //如此一来，程序崩溃时会自动进入CatchCrash.m的uncaughtExceptionHandler()方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24;  // 24小时fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];

    //若crash文件存在，则写入log并上传，然后删掉crash文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *errorLogPath = [NSString stringWithFormat:@"%@/Documents/error.log", NSHomeDirectory()];
    
    if ([fileManager fileExistsAtPath:errorLogPath]) {
        //用CocoaLumberJack库的fileLogger.logFileManager自带的方法创建一个新的Log文件，这样才能获取到对应文件夹下排序的Log文件
        [fileLogger.logFileManager createNewLogFile];
        //此处必须用firstObject而不能用lastObject，因为是按照日期逆序排列的，即最新的Log文件排在前面
        NSString *newLogFilePath = [fileLogger.logFileManager sortedLogFilePaths].firstObject;
        NSError *error = nil;
        NSString *errorLogContent = [NSString stringWithContentsOfFile:errorLogPath encoding:NSUTF8StringEncoding error:nil];
        BOOL isSuccess = [errorLogContent writeToFile:newLogFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (!isSuccess) {
            NSLog(@"crash文件写入log失败: %@", error.userInfo);
        } else {
            NSLog(@"crash文件写入log成功");
            NSError *error = nil;
            BOOL isSuccess = [fileManager removeItemAtPath:errorLogPath error:&error];
            if (!isSuccess) {
                NSLog(@"删除本地的crash文件失败: %@", error.userInfo);
            }
        }
    }
    
    setenv("XcodeColors", "YES", 0);
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor whiteColor] backgroundColor:[UIColor grayColor] forFlag:DDLogFlagVerbose]; //设置文字为白色，背景为灰色。
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:[UIColor whiteColor] forFlag:DDLogFlagDebug];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor cyanColor] backgroundColor:[UIColor blueColor] forFlag:DDLogFlagInfo];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor lightGrayColor] backgroundColor:[UIColor orangeColor] forFlag:DDLogFlagWarning];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] forFlag:DDLogFlagError];
    
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; //Xcode控制台(NSLog)
    [DDLog addLogger:[DDASLLogger sharedInstance]]; //发送至苹果日志系统
 //    DDLogError(@"This is an error.");   //错误信息
//    DDLogWarn(@"This is a warning.");//警告信息
//    DDLogInfo(@"This is just a message.");//通知信息
//    DDLogVerbose(@"This is a verbose message."); //详细信息

//    DDLogVerbose(@"Verbose");
//    DDLogDebug(@"Debug");
//    DDLogInfo(@"Info");
//    DDLogWarn(@"Warn");
//    DDLogError(@"Error");

    
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
