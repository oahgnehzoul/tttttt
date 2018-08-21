//
//  PointRemindManager.m
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/8/21.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import "PointRemindManager.h"

@interface PointRemindManager ()

@property (nonatomic, strong) NSMutableArray *popStackViews;
@property (nonatomic, strong) PointReminderView *currentView;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PointRemindManager

- (instancetype)init {
    if (self = [super init]) {
        _popStackViews = @[].mutableCopy;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLoad) name:@"123" object:nil];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PointRemindManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)viewDidLoad {
    [self showRemindView:[PointReminderModel new]];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (!_popStackViews) {
        return;
    }
    NSDictionary *aps = userInfo[@"aps"];
    NSDictionary *alert = aps[@"alert"];
    
    PointReminderModel *model = [PointReminderModel new];
    model.title = alert[@"title"];
    model.subTitle = alert[@"body"];
    [_popStackViews addObject:model];
}

- (void)showRemindView:(PointReminderModel *)model {
    
    if (_popStackViews.count == 0) {
        return;
    }
    model = [_popStackViews objectAtIndex:0];
    PointReminderView *view = [[PointReminderView alloc] initWithFrame:CGRectMake(0,100, [UIScreen mainScreen].bounds.size.width, 68)];
    model = [PointReminderModel new];
    model.title = @"恭喜您！666生日积分已到账！";
    model.subTitle = @"来自资金账号首次登录汇金谷任务";
    model.type = PointReminderTypeNormal;
    [view setModel:model];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    self.currentView = view;
    view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 68);
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:(7 << 16) animations:^{
        view.frame = CGRectMake(0,729 - 68, [UIScreen mainScreen].bounds.size.width, 68);
    } completion:^(BOOL finished) {
        [_timer invalidate];
//        _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(dissmiss) userInfo:nil repeats:NO];
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dissmiss) userInfo:nil repeats:NO];
    }];
}

- (void)dissmiss {
    [_timer invalidate];
    [self.currentView removeFromSuperview];
    if (self.popStackViews.count) {
        [self.popStackViews removeObjectAtIndex:0];
        if (self.popStackViews.count) {
            [self showRemindView:self.popStackViews[0]];
        }
    }
    
}



@end
