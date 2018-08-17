//
//  PointReminderView.h
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/8/18.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PointReminderType) {
    PointReminderTypeNormal = 1,
    PointReminderTypeBirthday
};
@interface PointReminderModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, assign) PointReminderType type;

@end

@interface PointReminderView : UIView

- (void)setModel:(PointReminderModel *)model;

@end


NS_ASSUME_NONNULL_END
