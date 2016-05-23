//
//  AppDelegate.m
//  LoveWords
//
//  Created by youdingquan on 16/4/20.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "AppDelegate.h"
#import "WordDao.h"
#import "Word.h"
#import <MBProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
#pragma mark -
#pragma mark 推送本地通知
-(BOOL)scheduleLoacl{
    //获取上次的复习时间
    NSDate * ageDate = [[NSUserDefaults standardUserDefaults] objectForKey:REVIEW_TIME];
    //注册通知
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        //提醒时间
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        //提醒时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //提醒重复间隔
        notification.repeatInterval = kCFCalendarUnitEra;
        //提醒声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        //提醒标题
        notification.alertTitle = @"爱单词";
        //提醒内容
        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:20] timeIntervalSinceDate:ageDate];
        notification.alertBody = [NSString stringWithFormat:@"你已经有%ld天没复习单词了!",(NSInteger)time/60/60/24];
        //提醒数量
        notification.applicationIconBadgeNumber = 1;
        //通知信息
        NSDictionary * info = [NSDictionary dictionaryWithObject:@"test" forKey:@"name"];
        notification.userInfo = info;
        
        //判断是否发送通知
        if (time/60/60/24 < 2) {
            return NO;
        }
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark appDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //数据加载
    [Singleton shareInstance].firstArray = [WordDao findAtState:WordStateUnfamiliar];
    [Singleton shareInstance].secondArray = [WordDao findAtState:WordStateCommon];
    [Singleton shareInstance].thirdArray = [WordDao findAtState:WordStateProficiency];
    
    //本地通知注册
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    //单词复习时间初始化
    if (![[NSUserDefaults standardUserDefaults] dataForKey:REVIEW_TIME]) {
        NSDate * date = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*3];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:REVIEW_TIME];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    //当程序退出后台时,发送本地通知
    if ([self scheduleLoacl]) {
        //保证只有一个最新的通知
        while ([application scheduledLocalNotifications].count > 1) {
            [application cancelLocalNotification:[application scheduledLocalNotifications].firstObject];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //当有通知时，将IconNumber置为0
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
