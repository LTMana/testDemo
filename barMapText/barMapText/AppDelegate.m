//
//  AppDelegate.m
//  barMapText
//
//  Created by 刘博通 on 16/5/30.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "AppDelegate.h"
#import <iNaviCore/MBNaviSession.h>
#import <iNaviCore/MBExpandView.h>
@interface AppDelegate ()<MBNaviSessionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MBEngine sharedEngine].delegate = self;
    
    [[MBEngine sharedEngine] checkWithKey:@"11"];
    NSLog(@"engineVersion:%@",[[MBEngine sharedEngine] version]);
    
    // 1. 创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2. 设置根控制器
    self.window.rootViewController = [[UIViewController alloc]init];
    
    // 3. 成为主窗口并显示
    [self.window makeKeyAndVisible];
    
    [self getPrivateDocsDir];
    
    return YES;

  
}
/**
 *  设置私有路径
 */
- (void)getPrivateDocsDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"mapbar/cn/userdata"];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory]){
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
}


-(void)sdkAuthSuccessed{
    // 设置根控制器
    UIStoryboard *story = nil;
    story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.window.rootViewController = [story instantiateInitialViewController];
    
    NSLog(@"授权成功");
    // 防止 poi 参数被意外修改
    MBNaviSession* session = [MBNaviSession sharedInstance];
    MBNaviSessionParams* p = [MBNaviSessionParams defaultParams];
    session.params = p;
    session.delegate = self;
}

-(void)sdkAuthFailed:(MBSdkAuthError)errCode {
    
    NSLog(@"授权失败,原因:%u", errCode);
}

-(void)naviSessionExpandViewShow{
    // 启用路口放大功能
    [MBExpandView setEnable:YES];
    // 更改屏幕分辨率用于横竖屏切换
    [MBExpandView setViewWidth:320 height:200];
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
