//
//  PointRemindManager.h
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/8/21.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointReminderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointRemindManager : NSObject

+ (instancetype)sharedInstance;

- (void)showRemindView:(PointReminderModel *)model;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
