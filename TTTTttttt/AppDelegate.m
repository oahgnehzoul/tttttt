//
//  AppDelegate.m
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/5/3.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSLog(@"%@",userInfo);
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
