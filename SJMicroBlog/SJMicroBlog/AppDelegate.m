//
//  AppDelegate.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:kScreenB];
    self.window.rootViewController = [self determineIsFirst];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIViewController *)determineIsFirst {
    /**
     * 判断当前版本号，确定是否显示新手引导页
     */
    //取出当前版本
    NSString *currentVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    //取出本地存储版本
    NSString *localVersion = [[NSUserDefaults standardUserDefaults]objectForKey:kAppVersion];
    //判断两个版本是否相同，确定是否显示引导页
    if ([currentVersion isEqualToString:localVersion]) {
        return [self instantiateVCWithIdentifier:@"mainID"];
    }else {
        return [self instantiateVCWithIdentifier:@"guideID"];
    }
}

- (UIViewController *)instantiateVCWithIdentifier:(NSString *)VCID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:VCID];
}

- (void)guideEnd
{
    self.window.rootViewController = [self instantiateVCWithIdentifier:@"mainID"];
    //引导结束，更新本地保存的版本
    NSString *currentVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    //设置本地保存路径
    [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:kAppVersion];
    //更新到物理文件中
    [[NSUserDefaults standardUserDefaults]synchronize];
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
