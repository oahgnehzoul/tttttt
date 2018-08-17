//
//  ViewController.m
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/5/3.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import "ViewController.h"
#import "PointReminderView.h"
#import "PopupView.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    NSDate *date = [NSDate date];//零时区时间，不受手机所在地区影响,但如果手机自定义修改了时间，会影响
    NSLog(@"零区时间 = %@", date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:date];//NSDateFormatter 转化后是当前所在时区的准确时间
    NSLog(@"手机设置的时区时间 = %@", dateStr);
    
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSLog(@"上海时间 = %@",[formatter stringFromDate:date]);
    
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
    NSLog(@"东京时间 = %@",[formatter stringFromDate:date]);
    
    NSArray *zones = [NSTimeZone knownTimeZoneNames];
    for (NSString *zone in zones) {
        NSLog(@"时区名 = %@",zone);
    }
    */
//    UIImage *image = [UIImage imageNamed:@"bgView"];
    
//    self.view.backgroundColor = [UIColor yellowColor];
    
    PointReminderView *view = [[PointReminderView alloc] initWithFrame:CGRectMake(0,100, self.view.frame.size.width, 68)];
    PointReminderModel *model = [PointReminderModel new];
    model.title = @"恭喜您！666生日积分已到账！";
    model.subTitle = @"来自资金账号首次登录汇金谷任务";
    model.type = PointReminderTypeNormal;
    [view setModel:model];
//    [self.view addSubview:view];
    PopupView *popup = [PopupView popupViewWithContentView:view showType:PopupViewShowTypeSlideInFromBottom dismissType:PopupViewDismissTypeFadeOut maskType:PopupViewMaskTypeClear shouldDismissOnBackgroundTouch:NO shouldDismissOnContentTouch:NO];
    [popup show];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
