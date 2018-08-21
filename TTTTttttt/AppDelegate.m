//
//  AppDelegate.m
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/5/3.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "PointRemindManager.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            NSLog(@"ERROR:%@-%@",error.localizedFailureReason,error.localizedDescription);
        }
    }];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken -- >> %@",deviceToken);
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token for Easy APNs Provider:%@",pushToken);
}


//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
//}

//为什么会调用两次？？content-avaliable会影响老版本。

//1 aps里面不包含content-avaliable
/*
 如果 app 在前台 UIApplicationStateActive//0 会进willPresentNotification的方法；
 如果 app 一直在后台 不会进方法
 如果 app 点了通知栏消息进 app UIApplicationStateInactive//1 会进 didReceiveRemoteNotification
 
 */

//2 aps里面包含了content-avaliable
/*
 如果 app 在前台 UIApplicationStateActive//0 会先进willPresentNotification的方法,再进didReceiveRemoteNotification方法
 如果 app 一直在后台  UIApplicationStateBackground//2  会进didReceiveRemoteNotification方法
 如果 app 点了通知栏消息进 app UIApplicationStateInactive//1 会进 didReceiveRemoteNotification
 
 所以要后台的时候处理推送消息弹框需要增加content-avaliable,在didReceiveRemoteNotification里面增加判断，如果 state 是0就不要处理。因为0的时候肯定在一直前台，会进willPresentNotification方法里处理；
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[PointRemindManager sharedInstance] didReceiveRemoteNotification:notification.request.content.userInfo];
    NSString *str = [NSString stringWithFormat:@"willPresentNotification:%ld",[[UIApplication sharedApplication] applicationState]];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:action];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:vc animated:YES completion:nil];
    NSLog(@"willPresentNotification:%@\n state:%ld",notification.request.content.userInfo,[[UIApplication sharedApplication] applicationState]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSString *str = [NSString stringWithFormat:@"didReceiveRemoteNotification:%ld",[[UIApplication sharedApplication] applicationState]];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:action];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:vc animated:YES completion:nil];
    if ([[UIApplication sharedApplication] applicationState] == 0) {
        return;
    }
    if ([[UIApplication sharedApplication] applicationState] == 1) {
        //处理跳转。
    }
    if ([[UIApplication sharedApplication] applicationState] == 2) {
        [[PointRemindManager sharedInstance] didReceiveRemoteNotification:userInfo];
    }

    //根据 state 判断，如果是1，说明是从通知栏打开，跳转页面；如果是2，说明一直在后台，增加弹框
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    //在后台时UIApplicationStateBackground 2
    NSLog(@"applicationState:%ld",[[UIApplication sharedApplication] applicationState]);
    //点击推送消息进来时UIApplicationStateInactive 1
    //在前台的时候收到消息UIApplicationStateActive 0
    
    //工程里设置的Background Modes 好像不起作用啊！！！？？
    //测试的时候只和aps 里边是否有content-avaliable 有关？？
    /*  YES
    {
        "aps" : {
            "content-available" : 1,
            "alert" : {
                "title" : "标题测试",
                "body" : "睡觉了睡觉了11"
            },
            "badge" : 9,
            "sound" : "default"
        }
    }
     */
    
    /*   NO
     {
     "aps" : {
     "alert" : {
     "title" : "标题测试",
     "body" : "睡觉了睡觉了11"
     },
     "sound" : "default",
     "badge" : 9
     }
     }
     */
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
